require 'rails_helper'

describe PostsController, type: :controller do
  describe 'GET #index' do
    context 'with cached data' do
      let(:cached_posts) do
        [
          {
            'title' => 'Post 1',
            'source' => 'Source A',
            'publish_date' => '2023-10-30T08:00:00Z'
          },
          {
            'title' => 'Post 2',
            'source' => 'Source B',
            'publish_date' => '2023-10-29T10:00:00Z'
          }
        ]
      end

      before do
        allow(Redis).to receive(:new).and_return(double(get: cached_posts.to_json))
      end

      it 'assigns posts sorted by publish_date in descending order' do
        get :index
        expect(assigns(:posts)).to eq(cached_posts.sort_by { |post| post['publish_date'] }.reverse)
      end

      it 'filters posts by source' do
        get :index, params: { source: 'Source A' }
        expect(assigns(:posts)).to eq([cached_posts.first])
      end

      it 'filters posts by title' do
        get :index, params: { title: 'Post 2' }
        expect(assigns(:posts)).to eq([cached_posts.second])
      end

      it 'filters posts by publish_date' do
        get :index, params: { publish_date: '2023-10-30T08:00:00Z' }
        expect(assigns(:posts)).to eq([cached_posts.first])
      end
    end

    context 'without cached data' do
      it 'assigns an empty array to @posts' do
        get :index
        expect(assigns(:posts)).to eq([])
      end

      before do
        allow(Redis).to receive(:new).and_return(double(get: ""))
      end
    end

    it '200 in any case' do
      get :index
        expect(response.status).to eq(200)
    end

  end
end
