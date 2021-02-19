# frozen_string_literal: true

Dry::Types.load_extensions(:maybe)

module Sw
  module BaseServices
    # :nodoc:
    module Types
      UUID_REG_EXP_V4 = /^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i.freeze
      include Dry.Types()

      Uuid = Types::Strict::String
        .constructor { |el| el unless el.empty? }
        .constrained(format: UUID_REG_EXP_V4)
    end
  end
end
