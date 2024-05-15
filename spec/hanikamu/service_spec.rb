# frozen_string_literal: true

require "spec_helper"


RSpec.describe Hanikamu::Service do
  module Types
    include Dry.Types()
  end

  describe "#new" do
    it "is private" do
      expect { described_class.new }
        .to raise_error(NoMethodError)
    end
  end

  describe ".config" do
    describe "#whitelisted_errors" do
      let(:error) { Class.new(StandardError) }
      let(:service_with_error) do
        Class.new(described_class) do
          attribute :error, Types::Strict::Class

          def call!
            raise error, "Oh, no!"
          end

          define_singleton_method(:name) { "RSpecServiceWithError" }
        end
      end

      it "raises an error when the error is not whitelisted" do
        expect { service_with_error.call(error:) }.to raise_error(error)
      end

      context "when the error is whitelisted" do
        before do
          described_class.configure do |config|
            config.whitelisted_errors = [error]
          end
        end

        it "returns a Failure object when the error is whitelisted" do
          expect(service_with_error.call(error:)).to be_a(Dry::Monads::Failure)
        end
      end
    end
  end

  describe "#call!" do
    it "has to be declared in subclasses" do
      expect { described_class.call! }.to raise_error(NoMethodError)
    end
  end

  context "when passing the wrong argument type" do
    let(:failing_service) do
      Class.new(described_class) do
        attribute :some_string, Dry::Types["string"]

        def call!
          "hola"
        end

        define_singleton_method(:name) { "RSpecFailingService" }
      end
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

  context "when raising a Hanikam::Service::Error" do
    let(:failing_service) do
      Class.new(described_class) do
        def call!
          raise Hanikamu::Service::Error, "Oh, no!"
        end

        define_singleton_method(:name) { "RSpecFailingService" }
      end
    end

    describe ".call" do
      it "returns a failure monad for Hanikamu::Service::Error" do
        expect(failing_service.call).to be_a(Dry::Monads::Failure)
        expect(failing_service.call.failure.message).to eq("Oh, no!")
        expect(failing_service.call.failure.class).to be(Hanikamu::Service::Error)
      end
    end

    describe ".call!" do
      it "returns a failure monad for Hanikamu::Service::Error" do
        expect { failing_service.call! }.to raise_error(Hanikamu::Service::Error, "Oh, no!")
      end
    end
  end

  context "when raising a custom error inheriting from Hanikamu::Service::Error" do
    let(:failing_service) do
      Class.new(described_class) do
        attribute :error, Types::Strict::Class

        def call!
          raise error, "Oh, yes!"
        end

        define_singleton_method(:name) { "RSpecFailingService" }
      end
    end
    let(:error) { Class.new(Hanikamu::Service::Error) }

    describe ".call" do

      it "returns a failure monad for errors inheriting from WhiteListedError" do
        expect(failing_service.call(error:)).to be_a(Dry::Monads::Failure)
        expect(failing_service.call(error:).failure).to be_a(error)
        expect(failing_service.call(error:).failure.message).to eq("Oh, yes!")
        expect(failing_service.call(error:).failure.class.superclass).to be(Hanikamu::Service::Error)
      end
    end

    describe ".call!" do
      it "returns a failure monad for Hanikamu::Service::Error" do
        expect { failing_service.call!(error:) }.to raise_error(error, "Oh, yes!")
      end
    end
  end

  context "when the error is not manageable by Hanikamu::Service" do
    let(:failing_service) do
      Class.new(described_class) do
        def call!
          raise StandardError, "Unexpected error"
        end

        define_singleton_method(:name) { "RSpecFailingService" }
      end
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

  context "when using response helper" do
    let(:response_service) do
      Class.new(described_class) do
        attribute :hello, Dry::Types["string"]
        def call!
          response hola: hello
        end

        define_singleton_method(:name) { "RSpecResponseService" }
      end
    end

    let(:conch) { "caracola" }

    describe ".call!" do
      it "responses with a Struct class" do
        expect(response_service.call!(hello: conch)).to be_a(Struct)
        expect(response_service.call!(hello: conch).hola).to be(conch)
      end
    end

    describe ".call" do
      it "responses with a Dry::Monads::Success class" do
        expect(response_service.call(hello: conch)).to be_a(Dry::Monads::Success)
        expect(response_service.call(hello: conch).success.hola).to be(conch)
      end
    end
  end

  context "when yielding to a block" do
    let(:yielding_service) do
      Class.new(described_class) do
        attribute :addition, Types::Integer

        def call!(&block)
          raise Hanikamu::Service::Error, "No block given" unless block

          yield(1 + addition)
        end

        define_singleton_method(:name) { "RSpecYieldingService" }
      end
    end

    describe ".call!" do
      it "yields the value when called with a block" do
        yielding_service.call!(addition: 3) do |value|
          expect(value).to eq(4)
        end
      end

      it "raises an error when called without a block" do
        expect { yielding_service.call!(addition: 3) }.to raise_error(Hanikamu::Service::Error, "No block given")
      end
    end

    describe ".call" do
      it "yields the value when called with a block" do
        yielding_service.call(addition: 3) do |value|
          expect(value).to eq(4)
        end
      end

      it "returns a Failure when called without a block" do
        expect(yielding_service.call(addition: 3)).to be_a(Dry::Monads::Failure)
      end
    end
  end
end
