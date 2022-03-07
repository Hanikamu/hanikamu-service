# Base image
FROM ruby:3.1.0-alpine

# Add our Gemfile and install gems
ADD Gemfile* ./
ADD hanikamu-base_service.gemspec ./


RUN bundle check || bundle install

WORKDIR "/app"
