require 'sidekiq-cron'

Sidekiq::Cron::Job.create(
  name: 'post_fetcher_job',
  cron: '*/1 * * * *', 
  class: 'PostFetcherJob'
)