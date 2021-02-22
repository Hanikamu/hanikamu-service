# frozen_string_literal: true

require "dry-struct"
require "dry-monads"

module Hanikamu
  # :nodoc
  class Service < Dry::Struct
    include Dry::Monads[:result]
    Error = Class.new(StandardError)

    class << self
      def call(options = {})
        options.empty? ? new.call : new(options)&.call
      rescue Dry::Struct::Error => e
        self::Failure.new(e.message)
      end

      def call!(options = {})
        options.empty? ? new.call! : new(options).call!
      end
    end

    # `call` should not be implemented in subclasses
    def call
      Success(call!)
    rescue => e
      return Failure(e.message) if whitelisted_error?(e.class)

      raise
    end

    def whitelisted_error?(error_klass)
      error_klass.is_a?(Error) ||
        error_klass.superclass == Hanikamu::Service::Error
    end

    private_class_method :new
  end
end
