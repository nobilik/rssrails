# app/models/feed.rb
class Feed < ApplicationRecord
  has_many :rss_items, dependent: :destroy
  validates :url, presence: true
  validates :url, uniqueness: true
  validate :valid_url

  def valid_url
    return if url.blank? || url =~ URI::DEFAULT_PARSER.make_regexp

    errors.add(:url, 'is not a valid URL')
  end
end
