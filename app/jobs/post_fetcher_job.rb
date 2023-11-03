require 'sidekiq-scheduler'

class PostFetcherJob
  include Sidekiq::Worker
  queue_as :default
  sidekiq_options retry: false

  def perform(*args)
    posts = Post.get_posts()
    return if posts.nil? # service not responding
    redis = Redis.new
    redis.set('cached_posts', posts)
    RssItem.save_to_db(posts)
  end
end
