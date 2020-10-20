Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/:merchant_id/items', to: 'items#index'
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
        get '/most_revenue', to: 'statistics#index'
      end
      namespace :items do
        get '/:item_id/merchant', to: 'merchant#show'
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
      end
      namespace :invoices do
        get '/most_expensive', to: 'statistics#index'
      end
      resources :merchants
      resources :items
    end
  end
end
