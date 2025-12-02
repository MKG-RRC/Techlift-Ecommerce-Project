Rails.application.routes.draw do
  # --------------------------
  # Authentication
  # --------------------------
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # --------------------------
  # Storefront
  # --------------------------
  resources :products, only: [:index, :show]
  resources :orders, only: [:index, :show]

  # Cart actions (session-based)
  resource :cart, only: [:show], controller: "cart" do
    post 'add/:id',    to: 'cart#add',    as: 'add'
    post 'remove/:id', to: 'cart#remove', as: 'remove'
    post 'update/:id', to: 'cart#update', as: 'update'
  end

  # --------------------------
  # Checkout
  # --------------------------
  get  "/checkout", to: "checkout#show",         as: :checkout
  post "/checkout", to: "checkout#process_order"

  # --------------------------
  # CMS Pages
  # --------------------------
  get "/about",   to: "pages#about"
  get "/contact", to: "pages#contact"
  get "/order/success", to: "orders#success"

  # --------------------------
  # Root
  # --------------------------
  root "products#index"
end
