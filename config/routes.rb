Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/:merchant_id/items', to: 'items#index'
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
        get '/most_revenue', to: 'statistics#most_revenue'
        get '/most_items', to: 'statistics#items'
        get '/:merchant_id/revenue', to: 'statistics#show'
      end

      namespace :items do
        get '/:item_id/merchants', to: 'merchant#show'
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
      end

      namespace :invoices do
        get '/most_expensive', to: 'statistics#index'
      end

      resources :merchants
      resources :items
      get 'revenue', to: 'revenue#index'
    end
  end
end
