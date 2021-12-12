Rails.application.routes.draw do
  resources :transactions
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  namespace :admin do
    resources :users
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "home#index"
end
