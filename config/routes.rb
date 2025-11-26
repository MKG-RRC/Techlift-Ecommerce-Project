Rails.application.routes.draw do
  # Front-end Storefront (products page)
  resources :products, only: [:index, :show]

  # Static CMS Pages
  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"

  # Devise + Admin
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root page
  root to: "products#index"
end
