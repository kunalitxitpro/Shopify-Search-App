# frozen_string_literal: true

class HomeController < AuthenticatedController
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 12})
    @webhooks = ShopifyAPI::Webhook.find(:all)
  end

  def products
    page = params[:page]
    @products = ShopifyAPI::Product.find(:all, params: { limit: 12, page: page })
    render json: {productsPartial: render_to_string('home/_products'), layout: false}
  end
end
