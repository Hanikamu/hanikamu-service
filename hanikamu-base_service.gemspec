# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

Gem::Specification.new do |s|
  s.name = "hanikamu-service"
  s.version = "0.1.0"
  s.authors = ["Nicolai Seerup", "Alejandro Jimenez"]
  s.summary = "This is the base service for all pattern designs used in hanikamu design"
  s.required_ruby_version = "> 2.5"

  s.files = Dir["{config,lib}/**/*", "Rakefile"]
  s.require_paths = ["lib"]

  s.add_dependency "dry-monads", "~> 1"
  s.add_dependency "dry-struct", "~> 1"

  s.add_development_dependency "bundler", ">= 2"
  s.add_development_dependency "pry", ">= 0.14.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 3.0"
end
