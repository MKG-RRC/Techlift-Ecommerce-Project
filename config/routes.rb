Rails.application.routes.draw do
  resources :products, only: [:index, :show]
  resources :orders, only: [:show]


  resource :cart, only: [:show], controller: "cart" do
    post 'add/:id', to: 'cart#add', as: 'add'
    post 'remove/:id', to: 'cart#remove', as: 'remove'
    post 'update/:id', to: 'cart#update', as: 'update'
  end

  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"
  get "checkout", to: "checkout#show"
  post "checkout", to: "checkout#process_order"

  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: "products#index"
end
