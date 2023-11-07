require 'rails_helper'

RSpec.describe 'RssItems', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/rss_items'
      expect(response).to have_http_status(:success)
    end
  end
end
