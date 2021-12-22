Rails.application.routes.draw do
  resources :transactions
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  get 'stock', to: 'stocks#show', as: 'stock'
  get 'stocks', to: 'stocks#index', as: 'stocks'
  post 'stock/buy', to: 'stocks#buy', as: 'stock_buy'
  post 'stock/sell', to: 'stocks#sell', as: 'stock_sell'

  namespace :admin do
    resources :users do
      member do
        patch 'approve'
        patch 'reject'
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "home#index"
end
