require 'rails_helper'

describe Post, type: :model do
  describe '.getPosts' do
    it 'fetches and returns posts from feeds' do
      feeds = Feed.all
      data = { urls: feeds.map { |feed| feed.url } }

      allow(Post).to receive(:fetchPosts).and_return('[{"title": "Test Post 1"}, {"title": "Test Post 2"}]')

      posts = JSON.parse(Post.getPosts)

      expect(posts).to be_an_instance_of(Array)
      expect(posts).to include({ 'title' => 'Test Post 1' }, { 'title' => 'Test Post 2' })
    end
  end

  describe '.fetchPosts' do
    it 'fetches and returns data from a given URL' do
        url = Rails.application.config.api_host + "/parse"
        data = { urls: ['http://feeds.bbci.co.uk/news/rss.xml', 'https://techcrunch.com/rssfeeds'] }
        result = Post.fetchPosts(url, data)
        expect(JSON.parse(result)).to be_an_instance_of(Array)
    end


    it 'returns nil on unsuccessful request' do
      url = Rails.application.config.api_host + "/parse"
      data = { urls: ['http://example.com/feed, https://techcrunch.com/rssfeeds'] }

      allow(Net::HTTP).to receive(:start).and_raise(StandardError)

      result = Post.fetchPosts(url, data)

      expect(result).to be_nil
    end
  end
end
