# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gemspec

eval_gemfile "./Gemfile.runtime"

gem "activejob"
gem "activemodel"
gem "bundler", ">= 2"
gem "pry", ">= 0.14.0"
gem "rake"
gem "rspec", "~> 3.0"
gem "rubocop"
gem "rubocop-performance"
gem "rubocop-rspec"
