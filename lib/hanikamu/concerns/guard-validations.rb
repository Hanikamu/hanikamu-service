# frozen_string_literal: true

module Hanikamu
  # :nodoc
  class GuardValidations
    def initialize(service:)
      @service = service
    end

    def method_missing(method_name, *args, &block)
      service.send(method_name, *args, &block)
    end

    def respond_to_missing?(method_name, _include_private = true)
      service.respond_to?(method_name, include_private) || super
    end

    private

    attr_reader :service
  end
end
