Rails.application.routes.draw do

  get 'cash_in', to: 'transactions#new', as: 'cash_in'
  resources :transactions
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # devise_scope :user do
  #     root 'devise/sessions#new', as: :unauthenticated_root
  # end

  devise_scope :user do
    #pass a proc to access user methods https://stackoverflow.com/questions/4753871/how-can-i-redirect-a-users-home-root-path-based-on-their-role-using-devise/4754097#4754097
    authenticated :user, -> (u) {u.admin?} do 
      root 'admin/users#index', as: :authenticated_admin_root
    end
    authenticated :user do 
      root 'stocks#index', as: :authenticated_user_root
    end
  
    root 'devise/sessions#new', as: :unauthenticated_root
  end

  get 'stock', to: 'stocks#show', as: 'stock'
  get 'trade', to: 'stocks#index', as: 'trade'
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
end
