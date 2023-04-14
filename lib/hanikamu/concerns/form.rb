# frozen_string_literal: true

require "active_model"

module Hanikamu
  # :nodoc
  module Form
    extend ActiveSupport::Concern

    Error = Class.new(Hanikamu::Service::Error) do
      attr_reader :form

      def initialize(form)
        @form = form

        super(form.errors.full_messages.join(", "))
      end
    end

    included do
      include ActiveModel::Validations
    end

    class_methods do
      def call!(options = {})
        form = new(options)

        raise(Error, form) unless form.valid?

        super
      end
    end
  end
end
