# spec/services/single_feed_service_spec.rb
require 'rails_helper'

describe SingleFeedService do
  let(:feed) { create(:feed) }

  describe '#process_feed' do
    it 'fetches posts, saves them to the database, and handles errors' do
      posts = [{ title: 'Post 1', source: 'Source 1', link: 'Link 1' }]
      allow(SingleFeedService).to receive(:fetch_posts).and_return(posts)

      expect(SingleFeedService).to receive(:save_to_db).with(feed.id, posts)

      SingleFeedService.process_feed(feed)
    end

    it 'handles a case where fetching posts returns nil' do
      allow(SingleFeedService).to receive(:fetch_posts).and_return(nil)
      expect(SingleFeedService).not_to receive(:save_to_db)

      SingleFeedService.process_feed(feed)
    end
  end

  describe '.fetch_posts' do
    it 'fetches posts from the API' do
      feed_link = 'https://example.com/feed'

      response = double(body: [{ title: 'Post 1' }].to_json, is_a?: Net::HTTPSuccess)

      allow(Net::HTTP).to receive(:start).and_return(response)

      result = SingleFeedService.fetch_posts(feed_link)
      expect(result).to eq([{ title: 'Post 1' }])
    end

    it 'handles errors when fetching posts' do
      feed_link = 'https://example.com/feed'

      allow(Net::HTTP).to receive(:start).and_raise(StandardError)

      result = SingleFeedService.fetch_posts(feed_link)
      expect(result).to be_nil
    end
  end

  describe '.save_to_db' do
    it 'saves posts to the database' do
      feed_id = 1
      posts = [{ title: 'Post 1', source: 'Source 1', link: 'Link 1' }]

      allow(RssItem).to receive(:new).and_return(build(:rss_item))
      allow_any_instance_of(RssItem).to receive(:save).and_return(true)

      SingleFeedService.save_to_db(feed_id, posts)
    end

    it 'skips duplicate records and print other errors' do
      feed_id = 1
      posts = [{ title: 'Post 1', source: 'Source 1', link: 'Link 1' },
               { title: 'Post 1', source: 'Source 1', link: 'Link 1' }]

      rss_item_instance = build(:rss_item)
      allow(RssItem).to receive(:new).and_return(rss_item_instance)

      # Expect normal creation
      expect(RssItem).to receive(:new).with(posts[0]).and_return(rss_item_instance)
      expect(rss_item_instance).to receive(:save)

      # Expect raise an error on save
      expect(RssItem).to receive(:new).with(posts[1]).and_return(rss_item_instance)
      expect(rss_item_instance).to receive(:save).and_raise(ActiveRecord::RecordNotUnique)

      SingleFeedService.save_to_db(feed_id, posts)
    end
  end
end
