# frozen_string_literal: true

require "active_model"
require "hanikamu/concerns/guard-validations"

module Hanikamu
  # :nodoc
  module Guard
    extend ActiveSupport::Concern

    Error = Class.new(Hanikamu::Service::Error) do
      attr_reader :guard

      def initialize(guard)
        @guard = guard

        super(guard.errors.full_messages.join(", "))
      end
    end

    class_methods do
      def guards(&block)
        @guard_validations = self::GuardValidations.set_validations(&block)
      end

      def call!(options = {})
        if @guard_validations
          service = new(options)
          guard = @guard_validations.new(service: service)

          raise(Error, guard) unless guard.valid?
        end

        super
      end
    end

    def self.included(base)
      base.class_eval do
        const_set(
          :GuardValidations,
          Class.new(Hanikamu::GuardValidations) do
            include ActiveModel::Validations

            class << self
              def set_validations(&block)
                class_eval(&block)
                self
              end
            end
          end
        )
      end
    end
  end
end
