# frozen_string_literal: true

require "pathname"

SPEC_ROOT = Pathname(__FILE__).dirname

Dir[Pathname(__FILE__).dirname.join("support/**/*.rb").to_s].each do |file|
  require file
end

require "hanikamu-service"

require "pry"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.filter_run_when_matching :focus

  config.before do
    stub_const("TestFooModule", Module.new)
  end
end
