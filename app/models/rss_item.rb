# app/models/rss_item.rb
class RssItem < ApplicationRecord
  belongs_to :feed
  validates :feed_id, presence: true
  validates :link, uniqueness: { scope: %i[feed_id publish_date] }
end
