# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

Gem::Specification.new do |s|
  s.name = "hanikamu-service"
  s.version = "0.1.0"
  s.authors = ["Nicolai Seerup", "Alejandro Jimenez"]
  s.summary = "BaseService"
  s.required_ruby_version = "~> 2.7"

  s.files = Dir["{config,lib}/**/*", "Rakefile"]
  s.require_paths = ["lib"]

  s.add_dependency "dry-monads", "~> 1"
  s.add_dependency "dry-struct", "~> 1"


  s.add_development_dependency "bundler", ">= 2"
  s.add_development_dependency "byebug", ">= 3.4"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 3.0"
end
