require 'rails_helper'

describe FeedsController, type: :controller do
  let(:valid_attributes) { { url: 'http://example.com/feed' } }
  let(:valid_creation_attributes) { { urls: 'http://example.com/feed, https://techcrunch.com/rssfeeds' } }
  let(:invalid_creation_attributes) { { urls: '' } }

  describe 'GET #index' do
    it 'assigns all feeds to @feeds' do
      feed = Feed.create!(valid_attributes)
      get :index
      expect(assigns(:feeds)).to eq([feed])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested feed to @feed' do
      feed = Feed.create!(valid_attributes)
      get :show, params: { id: feed.to_param }
      expect(assigns(:feed)).to eq(feed)
    end
  end

  describe 'GET #new' do
    it 'assigns a new feed as @feed' do
      get :new
      expect(assigns(:feed)).to be_a_new(Feed)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested feed as @feed' do
      feed = Feed.create!(valid_attributes)
      get :edit, params: { id: feed.to_param }
      expect(assigns(:feed)).to eq(feed)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new feeds' do
        expect do
          post :create, params: { feed: valid_creation_attributes }
        end.to change(Feed, :count).by(valid_creation_attributes[:urls].split(/[,;\s\n\t\r\f\v]+/).length)
      end

      it 'redirects to the feed index' do
        post :create, params: { feed: valid_creation_attributes }
        expect(response).to redirect_to(:feeds)
      end
    end

    context 'with invalid params' do
      it 'redirects to the feed index' do
        post :create, params: { feed: invalid_creation_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) { { url: 'http://updated-example.com/feed' } }

    it 'updates the requested feed' do
      feed = Feed.create!(valid_attributes)
      patch :update, params: { id: feed.to_param, feed: new_attributes }
      feed.reload
      expect(feed.url).to eq(new_attributes[:url])
    end

    it 'redirects to the feed' do
      feed = Feed.create!(valid_attributes)
      patch :update, params: { id: feed.to_param, feed: new_attributes }
      expect(response).to redirect_to(feed)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested feed' do
      feed = Feed.create!(valid_attributes)
      expect do
        delete :destroy, params: { id: feed.to_param }
      end.to change(Feed, :count).by(-1)
    end

    it 'redirects to the feeds list' do
      feed = Feed.create!(valid_attributes)
      delete :destroy, params: { id: feed.to_param }
      expect(response).to redirect_to(feeds_url)
    end
  end
end
