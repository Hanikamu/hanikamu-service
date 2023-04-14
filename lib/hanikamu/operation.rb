# frozen_string_literal: true

require "hanikamu/service"
require "hanikamu/async-service"

module Hanikamu
  # :nodoc
  class Operation < Hanikamu::Service
    include AsyncService
  end
end
