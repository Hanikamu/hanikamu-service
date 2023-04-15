# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanikamu::Operation do
  let(:service) do
    class TestFooModule::Bar < Hanikamu::Operation
      attribute :greeting, Dry::Types["string"].optional
      attribute :context, Dry::Types["hash"]

      validates :greeting, presence: true

      guard do
        validates :state, inclusion: { in: %w[done] }
      end

      def call!
        "#{greeting} caracol!"
      end

      private

      def state
        context[:state]
      end
    end
    TestFooModule::Bar
  end

  let(:greeting) { "hola" }
  let(:context) { { state: state } }
  let(:state) { "done" }

  describe ".call!" do
    subject { service.call!(greeting: greeting, context: context) }

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

    context "when guard input is invalid" do
      let(:state) { "not_done" }

      it "raises a guard error" do
        expect { subject }.to raise_error(Hanikamu::Guard::Error)
      end

      it "is possible to access the guard object when rescuing from the error" do
        subject
      rescue Hanikamu::Guard::Error => error
        expect(error.guard).to be_a(Hanikamu::GuardValidations)
        expect(error.guard.errors.full_messages.join(", ")).to eq("State is not included in the list")
        expect(error.message).to eq("State is not included in the list")
      end
    end
  end

  describe ".call" do
    subject { service.call(greeting: greeting, context: context) }

    it "works" do
      expect(subject.success).to eq("hola caracol!")
    end

    context "when form input is invalid" do
      let(:greeting) { nil }

      it "returns a form error" do
        expect(subject.failure.message).to eq("Greeting can't be blank")
      end
    end

    context "when input is invalid" do
      let(:state) { "not_done" }

      it "returns a guard error" do
        expect(subject.failure.message).to eq("State is not included in the list")
      end
    end
  end

  context "modules" do
    it "inherits from Hanikamu::Service" do
      expect(described_class.ancestors).to include(Hanikamu::Service)
    end

    it "includes Hanikamu::Async module" do
      expect(described_class.included_modules).to include(Hanikamu::Async)
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
