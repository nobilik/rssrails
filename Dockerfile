# syntax = docker/dockerfile:1.4

# First stage: Base image
ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_DEPLOYMENT="1" \
    # normally it should be passed with args
    SECRET_KEY_BASE="1" 
# API_PORT=2345
# rss_servise env
# PORT="2345"

# Update gems and bundler
RUN gem update --system --no-document && \
    gem install -N bundler

# Install packages needed to install Node.js
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install Node.js
ARG NODE_VERSION=20.9.0
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    rm -rf /tmp/node-build-master

# Second stage: Build the Ruby on Rails application
FROM base as rails_build

# Install build dependencies for Rails
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential pkg-config

# Copy Rails application code
COPY rssrails/Gemfile rssrails/Gemfile.lock ./
RUN bundle install && \
    bundle exec bootsnap precompile --gemfile && \
    rm -rf ~/.bundle/ $BUNDLE_PATH/ruby/*/cache $BUNDLE_PATH/ruby/*/bundler/gems/*/.git
COPY ./rssrails .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/
RUN SECRET_KEY_BASE=1 RAILS_BUILD=1 bundle exec rake assets:precompile

# Third stage: Build the Go RSS service
FROM golang:1.21.3-bookworm as go_build

WORKDIR /app

# Copy Go RSS service code
COPY RSSReaderService/go.mod RSSReaderService/go.sum ./
RUN go mod download
COPY ./RSSReaderService ./

# Build Go RSS service
RUN CGO_ENABLED=0 GOOS=linux go build -o /rss_service

# Final stage: Combine Ruby on Rails and Go RSS service
FROM base as final

# Install packages needed for deployment for both applications
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libsqlite3-0 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts from Ruby on Rails
COPY --from=rails_build /usr/local/bundle /usr/local/bundle
COPY --from=rails_build /rails /rails

# Copy built RSS service from Go
COPY --from=go_build /rss_service /rss_service

# Create non-root user for both applications
RUN groupadd -f -g 1000 rails && \
    useradd -u 1001 -g 1000 rails --create-home --shell /bin/bash && \
    groupadd -f -g 1000 rss && \
    useradd -u 1000 -g 1000 rss --create-home --shell /bin/bash && \
    mkdir /data && \
    chown -R rails:rails db log storage tmp /data && \
    chown -R rss:rss /data

# Expose ports for both applications
EXPOSE 3000
EXPOSE 2345

# Set the entry point and command for both applications
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
CMD ["./bin/rails", "server"]
