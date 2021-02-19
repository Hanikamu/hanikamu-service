# frozen_string_literal: true

require "spec_helper"

RSpec.describe Sw::BaseServices::Base do
  describe "#new" do
    it "is private" do
      expect { described_class.new }
        .to raise_error(NoMethodError, "private method `new' called for Sw::BaseServices::Base:Class")
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
        Class.new(described_class) do
          CustomError = Class.new(self::WhiteListedError)
          def call!
            raise CustomError, "Oh, yes!"
          end
        end
      end

      it "returns a failure monad for errors inheriting from WhiteListedError" do
        expect(failing_service.call).to be_a(Dry::Monads::Failure)
      end

      it "raises an error when is a none WhiteListedError" do
        allow(described_class).to receive(:call).and_raise(StandardError.new("Oh, no!"))

        expect { failing_service.call }.to raise_error(StandardError, "Oh, no!")
      end
    end
  end
end
