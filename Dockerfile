# Base image
FROM ruby:4.0-slim
RUN apt-get update && apt-get install -y readline-common build-essential

WORKDIR "/app"

# Add our Gemfile and install gems
ADD Gemfile* ./
ADD hanikamu-base_service.gemspec ./
RUN bundle install
