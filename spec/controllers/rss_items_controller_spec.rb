require 'rails_helper'

describe RssItemsController, type: :controller do
  describe 'GET #index' do
    context 'with data' do
      let!(:feed) { create(:feed) }
      let!(:rss_items) do
        [
          create(:rss_item, title: 'rss_item 1', source: 'Source A', publish_date: '2023-10-30T08:00:00Z', feed:),
          create(:rss_item, title: 'rss_item 2', source: 'Source B', publish_date: '2023-10-29T10:00:00Z', feed:)
        ]
      end

      it 'assigns rss_items sorted by publish_date in descending order' do
        get :index
        expect(assigns(:rss_items)).to eq(rss_items.sort_by { |rss_item| rss_item.publish_date }.reverse)
      end

      it 'filters rss_items by source' do
        get :index, params: { source: 'Source A' }
        expect(assigns(:rss_items)).to eq([rss_items.first])
      end

      it 'filters rss_items by title' do
        get :index, params: { title: 'rss_item 2' }
        expect(assigns(:rss_items)).to eq([rss_items.second])
      end

      it 'filters rss_items by publish_date' do
        get :index, params: { publish_date: '2023-10-30T08:00:00Z' }
        expect(assigns(:rss_items)).to eq([rss_items.first])
      end
    end

    context 'without data' do
      it 'assigns an empty array to @rss_items' do
        get :index
        expect(assigns(:rss_items)).to eq([])
      end
    end

    it '200 in any case' do
      get :index
      expect(response.status).to eq(200)
    end
  end
end
