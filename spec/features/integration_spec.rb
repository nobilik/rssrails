require 'rails_helper'

describe 'rss app', type: :system do
  it 'should visit the homepage' do
    visit '/'
    expect(page).to have_content('Filter by Source')
    click_link 'Feeds'
    expect(current_path).to eq('/feeds')
  end

  it 'should visit feeds index' do
    visit '/feeds'
    expect(page).to have_content('URL')
    expect(page).to have_content('Actions')
    click_link 'New feed'
    expect(current_path).to eq('/feeds/new')
    click_link 'Back to feeds'
    expect(current_path).to eq('/feeds')
  end

  it 'should visit feeds new' do
    visit '/feeds/new'

    fill_in 'Urls', with: 'http://feeds.bbci.co.uk/news/world/rss.xml,
		http://rss.cnn.com/rss/cnn_topstories.rss'
    click_button 'Save'

    expect(page).to have_current_path('/feeds')
  end

  it 'should visit feeds new with bad url' do
    visit '/feeds/new'
    element = find(:css, "textarea[id$='feed_urls']")
    element.fill_in with: 'http://feeds.bbci.co.uk/news/world/rss.xml,
		dsvsvrbrbrb'
    click_button 'Save'

    expect(page).to have_content('The following errors prevented some feeds from being saved')
  end
end
