Rails.application.routes.draw do
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'

  namespace :app_proxy do
    root action: 'index'
    get '/allprods', action: 'index'
    # simple routes without a specified controller will go to AppProxyController

    # more complex routes will go to controllers in the AppProxy namespace
    # 	resources :reviews
    # GET /app_proxy/reviews will now be routed to
    # AppProxy::ReviewsController#index, for example
  end
  get 'all_products', to: 'home#products', as: :all_products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
