class CreateRssItems < ActiveRecord::Migration[7.1]
  def change
    create_table :rss_items do |t|
      t.string :title
      t.string :source
      t.string :source_url
      t.string :link
      t.datetime :publish_date
      t.string :description

      t.timestamps
    end

    add_index :rss_items, [:link, :source_url, :publish_date], unique: true
  end
end
