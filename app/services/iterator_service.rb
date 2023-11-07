# app/services/iterator_service.rb
class IteratorService
  def self.iterate_feeds
    Feed.in_batches(of: 100) do |feeds|
      feeds.each do |feed|
        SingleFeedService.process_feed(feed)
      end
    end
  end
end
