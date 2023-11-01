class Post
require 'net/http'
require 'json'

def self.get_posts()
    feeds = Feed.all
    data = { urls: feeds.map {|el| el.url }}
    fetch_posts(Rails.application.config.api_host + "/parse", data)
end

def self.fetch_posts(url, data)
    uri = URI(url)
 
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = data.to_json

    begin
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(request)
        end

        if response.is_a?(Net::HTTPSuccess)
        return response.body
        else
        return nil  # Return nil if the request was not successful
        end
    rescue StandardError => e
        puts "Error: #{e.message}"
        return nil
    end
end

end
