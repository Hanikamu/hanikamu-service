# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

Gem::Specification.new do |s|
  s.name = "hanikamu-service"
  s.version = "0.1.6"
  s.authors = ["Nicolai Seerup", "Alejandro Jimenez"]
  s.summary = "This is the base service for all pattern designs used in hanikamu design"
  s.required_ruby_version = ">= 3.1"

  s.homepage      = "https://github.com/Hanikamu/hanikamu-service"
  s.license       = "MIT"

  s.files = Dir["{config,lib}/**/*", "Rakefile"]
  s.require_paths = ["lib"]

  s.add_dependency "dry-configurable", "~> 1.1.0"
  s.add_dependency "dry-monads", "~> 1.6.0"
  s.add_dependency "dry-struct", "~> 1.8.0"

  s.metadata["rubygems_mfa_required"] = "true"
end
