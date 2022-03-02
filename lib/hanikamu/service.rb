# frozen_string_literal: true

require "dry-struct"
require "dry-monads"

module Hanikamu
  # :nodoc
  class Service < Dry::Struct
    extend Dry::Monads[:result]
    Error = Class.new(StandardError)

    class << self
      def call(options = {})
        # binding.pry
        Success(call!(options))
      rescue  => e
        return Failure.new(e) if whitelisted_error?(e.class)
        raise e
      end

      def call!(options = {})
        options.empty? ? new.send(:call!) : new(options).send(:call!)
      end
    end

    private
    def self.whitelisted_error?(error_klass)
      error_klass == Hanikamu::Service::Error ||
        error_klass.superclass == Hanikamu::Service::Error ||
        error_klass == Dry::Struct::Error
    end

    def response(**args)
      klass = self.class
      klass.const_set(:Response, Struct.new(*args.keys, keyword_init: true)) unless klass.const_defined?(:Response)
      klass::Response.new(**args)
    end

    private_class_method :new
  end
end
