Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/:merchant_id/items', to: 'items#index'
      end
      resources :merchants
      resources :items
    end
  end
end
