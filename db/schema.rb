# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_11_06_194001) do
  create_table "feeds", force: :cascade do |t|
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url"], name: "index_feeds_on_url", unique: true
  end

  create_table "rss_items", force: :cascade do |t|
    t.string "title"
    t.string "source"
    t.string "source_url"
    t.string "link"
    t.datetime "publish_date"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "feed_id"
    t.index ["feed_id", "link", "publish_date"], name: "index_rss_items_on_feed_id_and_link_and_publish_date", unique: true
  end

end
