require 'rails_helper'

RSpec.describe "RssItems", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/rss_items/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/rss_items/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/rss_items/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/rss_items/update"
      expect(response).to have_http_status(:success)
    end
  end

end
