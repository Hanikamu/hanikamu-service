# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanikamu::Guard do
  let(:service) do
    class TestFooModule::Bar < Hanikamu::Service
      include Hanikamu::Guard
      attribute :context, Dry::Types["hash"]

      guards do
        validates :state, inclusion: { in: %w[done] }
      end

      def call!
        "state: #{ state }"
      end

      private

      def state
        context[:state]
      end
    end
    TestFooModule::Bar
  end

  let(:context) { { state: state } }
  let(:state) { "done" }

  describe ".call" do
    subject { service.call(context: context) }

    it "works" do
      expect(subject.success).to eq("state: done")
    end

    context "when input is invalid" do
      let(:state) { "not_done" }

      it "returns a guard error" do
        expect(subject.failure.message).to eq("State is not included in the list")
      end
    end
  end

  describe ".call!" do
    subject { service.call!(context: context) }

    it "works" do
      expect(subject).to eq("state: done")
    end

    context "when input is invalid" do
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

    context "when guards are not defined" do
      let(:service) do
        class TestFooModule::Bar < Hanikamu::Service
          include Hanikamu::Guard
          attribute :context, Dry::Types["hash"]

          def call!
            "state: #{ state }"
          end

          private

          def state
            context[:state]
          end
        end
        TestFooModule::Bar
      end

      it "works" do
        expect(subject).to eq("state: done")
      end
    end

    context "when validation is invalid" do
      subject { service.call!(context: context) }

      let(:service) do
        class TestFooModule::Bar < Hanikamu::Service
          include Hanikamu::Guard
          attribute :context, Dry::Types["hash"]

          guards do
            validates :state, inclusion: { in: %w[done] }
          end

          def call!
            "state: #{ state }"
          end
        end
        TestFooModule::Bar
      end

      it "raises a guard error" do
        expect { subject }.to raise_error(NoMethodError)
      end
    end
  end
end
