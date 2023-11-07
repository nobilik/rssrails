require 'sidekiq-scheduler'

# app/jobs/fetcher_job.rb
class FetcherJob
  include Sidekiq::Worker
  queue_as :default
  sidekiq_options retry: false

  def perform(*_args)
    IteratorService.iterate_feeds
  end
end
