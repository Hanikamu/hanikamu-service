# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanikamu::Operation do
  let(:service) do
    class TestFooModule::Bar < Hanikamu::Operation
      attribute :greeting, Dry::Types["string"].optional

      validates :greeting, presence: true

      def call!
        "#{greeting} caracol!"
      end
    end
    TestFooModule::Bar
  end

  let(:greeting) { "hola" }

  describe ".call" do
    subject { service.call(greeting: greeting) }

    it "works" do
      expect(subject.success).to eq("hola caracol!")
    end

    context "when form input is invalid" do
      let(:greeting) { nil }

      it "returns a form error" do
        expect(subject.failure.message).to eq("Greeting can't be blank")
      end
    end
  end

  describe ".call!" do
    subject { service.call!(greeting: greeting) }

    it "works" do
      expect(subject).to eq("hola caracol!")
    end

    context "when form input is invalid" do
      let(:greeting) { nil }

      it "raises a form error" do
        expect { subject }.to raise_error(Hanikamu::Form::Error)
      end

      it "is possible to access the form object when rescuing from the error" do
        subject
      rescue Hanikamu::Form::Error => error
        expect(error.form).to be_a(Hanikamu::Form)
        expect(error.message).to eq("Greeting can't be blank")
      end
    end
  end

  context "modules" do
    it "inherits from Hanikamu::Service" do
      expect(described_class.ancestors).to include(Hanikamu::Service)
    end

    it "includes Hanikamu::AsyncService module" do
      expect(described_class.included_modules).to include(Hanikamu::AsyncService)
    end

    it "includes Hanikamu::Form module" do
      expect(described_class.included_modules).to include(Hanikamu::Form)
    end

    it "includes Hanikamu::Guard module" do
      expect(described_class.included_modules).to include(Hanikamu::Guard)
    end
  end

  pending("add some integration specs here with all modules working together")
end
