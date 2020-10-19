Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/:merchant_id/items', to: 'items#index'
        get 'find', to: 'search#show'
      end
      namespace :items do
        get '/:item_id/merchant', to: 'merchant#show'
        get 'find', to: 'search#show'
      end
      resources :merchants
      resources :items
    end
  end
end
