class RssItem < ApplicationRecord
    def self.save_to_db(json_posts)
        posts = JSON.parse(json_posts)
        posts.each do |post|
        item = RssItem.new(post)
        item.save
        rescue
            next
        end
    end
end
