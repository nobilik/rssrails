# app/services/single_feed_service.rb
require 'net/http'

class SingleFeedService
  API_URI = URI("#{Rails.application.config.api_host}/parse")
  def self.process_feed(feed)
    res = fetch_posts(feed.url)
    return if res.nil?

    save_to_db(feed.id, res)
  end

  def self.fetch_posts(feed_link)
    # uri = URI(url)

    data = { urls: [feed_link] }

    request = Net::HTTP::Post.new(API_URI)
    request['Content-Type'] = 'application/json'
    request.body = data.to_json

    begin
      response = Net::HTTP.start(API_URI.hostname, API_URI.port, use_ssl: API_URI.scheme == 'https') do |http|
        http.request(request)
      end

      return JSON.parse(response.body, { symbolize_names: true }) if response.is_a?(Net::HTTPSuccess)

      nil
    rescue StandardError => e
      puts "Error: #{e.message}"
      nil
    end
  end

  def self.save_to_db(feed_id, posts)
    posts.each do |post|
      item = RssItem.new(post)
      begin
        item.feed_id = feed_id
        item.save
      rescue ActiveRecord::RecordNotUnique
        # duplicate record
        next
      rescue StandardError => e
        # Handle other errors
        puts "Error: #{e.message}"
        next
      end
    end
  end
end
