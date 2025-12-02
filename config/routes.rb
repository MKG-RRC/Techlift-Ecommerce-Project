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
  get  "/checkout", to: "checkout#show", as: :checkout
  post "/checkout", to: "checkout#create"
  get  "/checkout/success", to: "checkout#success", as: :checkout_success

  # --------------------------
  # CMS Pages
  # --------------------------
  get "/about",   to: "pages#about"
  get "/contact", to: "pages#contact"
  get "/home",    to: "pages#home"
  get "/order/success", to: "orders#success"

  # --------------------------
  # Root
  # --------------------------
  root "pages#home"
end
