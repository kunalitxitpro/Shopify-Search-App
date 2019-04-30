Rails.application.routes.draw do
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'
  resources :product_settings, only: [:update, :edit]
  resources :test_admins
  resources :test_proxies

  namespace :app_proxy do
    root action: 'index'
    get 'index', to: 'index'
  end
  get '/apps/index', as: :proxy_prod
  get 'all_products', to: 'home#products', as: :all_products
  get '/products/sync', to: 'product_settings#sync', as: :sync_products

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
