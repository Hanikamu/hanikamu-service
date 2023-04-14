# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

Gem::Specification.new do |s|
  s.name = "hanikamu-service"
  s.version = "0.1.2"
  s.authors = ["Nicolai Seerup", "Alejandro Jimenez"]
  s.summary = "This is the base service for all pattern designs used in hanikamu design"
  s.required_ruby_version = ">= 2.7"

  s.homepage      = "https://github.com/Hanikamu/hanikamu-service"
  s.license       = "MIT"

  s.files = Dir["{config,lib}/**/*", "Rakefile"]
  s.require_paths = ["lib"]

  s.add_dependency "activejob"
  s.add_dependency "activemodel"
  s.add_dependency "dry-monads", "~> 1"
  s.add_dependency "dry-struct", "~> 1"

  s.metadata["rubygems_mfa_required"] = "true"
end
