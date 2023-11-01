require 'rails_helper'

describe 'rss app feed actions', type: :system do
  before(:each) do
    @feeds = create_list(:feed, 5)
    visit feeds_path
  end

  it 'should visit feeds index for show' do
    feed = @feeds.first
    click_link('Show', href: feed_path(feed))
    expect(current_path).to match(%r{/feeds/\d+})
  end

  it 'should visit show for back' do
    feed = @feeds.first
    visit feed_path(feed)
    expect(current_path).to match(%r{/feeds/\d+})
    click_link('Back to feeds')
    expect(current_path).to eq('/feeds')
  end

  it 'should visit show for edit' do
    feed = @feeds.first
    visit feed_path(feed)
    click_link('Edit this feed')
    expect(current_path).to eq(edit_feed_path(feed))
  end
end