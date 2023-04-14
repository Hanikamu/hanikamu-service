# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanikamu::Form do
  let(:service) do
    class TestFooModule::Bar < Hanikamu::Service
      include Hanikamu::Form
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

    context "when input is invalid" do
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

    context "when input is invalid" do
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
end
