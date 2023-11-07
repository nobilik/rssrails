Rails.application.routes.draw do
  resources :feeds
  resources :rss_items do
    collection do
      get 'reset_filters'
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'rss_items#index'
end
