# Base image
FROM ruby:3.2.3-bullseye

# Add our Gemfile and install gems
ADD Gemfile* ./
ADD hanikamu-base_service.gemspec ./

RUN bundle check || bundle install

WORKDIR "/app"
