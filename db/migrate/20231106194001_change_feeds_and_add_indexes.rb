class ChangeFeedsAndAddIndexes < ActiveRecord::Migration[7.1]
  def change
    add_column :rss_items, :feed_id, :integer
    remove_index :rss_items, %i[link source_url publish_date]
    add_index :rss_items, %i[feed_id link publish_date], unique: true
    add_index :feeds, :url, unique: true
  end
end
