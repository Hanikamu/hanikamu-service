# frozen_string_literal: true

module Hanikamu
  # :nodoc
  class Operation < Hanikamu::Service
    include AsyncService
    include Form
    include Guard
  end
end
