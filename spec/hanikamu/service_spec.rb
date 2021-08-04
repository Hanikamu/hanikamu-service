# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanikamu::Service do
  describe "#new" do
    it "is private" do
      expect { described_class.new }
        .to raise_error(NoMethodError, "private method `new' called for Hanikamu::Service:Class")
    end
  end

  describe "#call!" do
    it "has to be declared in subclasses" do
      expect { described_class.call! }.to raise_error(NoMethodError)
    end
  end

  describe "#call" do
    context "with a failing service" do
      let(:failing_service) do
        stub_const("TestFooModule", Module.new)
        class TestFooModule::Bar < Hanikamu::Service
          CustomError = Class.new(self::Error)
          def call!
            raise CustomError, "Oh, yes!"
          end
        end
        TestFooModule::Bar
      end

      it "returns a failure monad for errors inheriting from WhiteListedError" do
        expect(failing_service.call).to be_a(Dry::Monads::Failure)
        expect(failing_service.call.failure).to be_a(failing_service::CustomError)
        expect(failing_service.call.failure.message).to eq("Oh, yes!")
        expect(failing_service.call.failure.class.superclass).to be(Hanikamu::Service::Error)
      end

      context "when using the custom service error" do
        let(:failing_service) do
          stub_const("TestFooModule", Module.new)
          class TestFooModule::Bar < Hanikamu::Service
            def call!
              raise Error, "Oh, no!"
            end
          end
          TestFooModule::Bar
        end

        it "returns a failure monad for Hanikamu::Service::Error" do
          expect(failing_service.call).to be_a(Dry::Monads::Failure)
          expect(failing_service.call.failure.message).to eq("Oh, no!")
          expect(failing_service.call.failure.class).to be(Hanikamu::Service::Error)
        end
      end

      it "raises an error when is a none WhiteListedError" do
        allow(described_class).to receive(:call).and_raise(StandardError.new("Oh, no!"))

        expect { failing_service.call }.to raise_error(StandardError, "Oh, no!")
      end
    end
  end
end
