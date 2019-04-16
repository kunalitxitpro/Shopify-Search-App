class AppProxyController < ApplicationController
   include ShopifyApp::AppProxyVerification

  def index
    # @products = ProductSearch.new(product_params).search
    shop = Shop.find_by(shopify_domain: params[:shop])
    if shop
      shop.with_shopify_session do
        @products = ShopifyAPI::Product.find(:all, params: {limit: 36})
      end
    end
    render layout: false, content_type: 'application/liquid'
  end

  private

  def product_params
    {limit: 36, title: params[:brand], product_type: params[:product_type], tag: params[:size], page: params[:page]}
  end

end
