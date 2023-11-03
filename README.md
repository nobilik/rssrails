# README

We have 3 pages:

Feeds - you can manage sources
RSS - it's full list of currently existed posts in sources stored in Redis
Archive - here you can manage stored posts in db // but if you delete post that still exists in RSS souce it will appear again
// can be solved with soft delete for example

program makes requests every minute to ENV['API_HOST'] || "http://127.0.0.1:2345"
where back runs
If starts with docker specify the API_HOST in docker compose before running

rails db:migrate RAILS_ENV="production" // sorry

prebuild base image
docker build -t rails_rss_base:0.1 .
then
start with docker-compose up --build

or
// redis server required

1. rails server
2. sidekiq -C config/sidekiq.yml
