# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanikamu::Service do
  describe "#new" do
    it "is private" do
      expect { described_class.new }
        .to raise_error(NoMethodError)
    end
  end

  describe "#call!" do
    it "has to be declared in subclasses" do
      expect { described_class.call! }.to raise_error(NoMethodError)
    end
  end

  describe ".call" do
    context "with a failing service" do
      let(:failing_service) do
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

      context "when passing the wrong argument type" do
        let(:failing_service) do
          class TestFooModule::Bar < Hanikamu::Service
            attribute :some_string, Dry::Types["string"]

            def call!
              "hola"
            end
          end
          TestFooModule::Bar
        end

        describe ".call" do
          it "returns a monadic Failure response" do
            expect(failing_service.call(some_string: 3)).to be_a(Dry::Monads::Failure)
          end
        end

        describe ".call!" do
          it "returns a Dry::Struct::Error" do
            expect { failing_service.call!(some_string: 3) }.to raise_error(Dry::Struct::Error)
          end
        end
      end

      context "when using the custom service error" do
        let(:failing_service) do
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

      context "when the error is not manageable by Hanikamu::Service" do
        let(:failing_service) do
          class TestFooModule::Bar < Hanikamu::Service
            def call!
              raise StandardError, "Unexpected error"
            end
          end
          TestFooModule::Bar
        end

        describe ".call" do
          it "raises the error" do
            expect { failing_service.call }.to raise_error(StandardError)
          end
        end

        describe ".call!" do
          it "raises the error" do
            expect { failing_service.call! }.to raise_error(StandardError)
          end
        end
      end

      it "raises an error when is a none WhiteListedError" do
        allow(described_class).to receive(:call).and_raise(StandardError.new("Oh, no!"))

        expect { failing_service.call }.to raise_error(StandardError, "Oh, no!")
      end
    end
  end

  context "when using response helper" do
    let(:response_service) do
      class TestFooModule::Bar < Hanikamu::Service
        attribute :hello, Dry::Types["string"]
        def call!
          response hola: hello
        end
      end
      TestFooModule::Bar
    end

    let(:conch) { "caracola" }

    describe ".call!" do
      it "responses with a Struct class" do
        expect(response_service.call!(hello: conch)).to be_a(Struct)
        expect(response_service.call!(hello: conch).hola).to be(conch)
      end
    end

    describe ".call" do
      it "responses with a Struct class" do
        expect(response_service.call(hello: conch)).to be_a(Dry::Monads::Success)
        expect(response_service.call(hello: conch).success.hola).to be(conch)
      end
    end

  end
end
