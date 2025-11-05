# Base image
FROM ruby:3.4.7-slim
RUN apt-get update && apt-get install -y readline-common
# Add our Gemfile and install gems
ADD Gemfile* ./
ADD hanikamu-base_service.gemspec ./


WORKDIR "/app"
