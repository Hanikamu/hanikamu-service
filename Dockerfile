# Base image
FROM ruby:3.2.1-slim

# Add our Gemfile and install gems
ADD Gemfile* ./
ADD hanikamu-base_service.gemspec ./


RUN bundle check || bundle install

WORKDIR "/app"
