# frozen_string_literal: true

class HomeController < AuthenticatedController
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 36 })
    # @products = ProductSearch.new({ limit: 36, tag: 'for_guys', title: 'Adidas' }).search
    @webhooks = ShopifyAPI::Webhook.find(:all)
  end

  def products
    page = params[:page]
    @products = ShopifyAPI::Product.find(:all, params: { limit: 36, page: page })
    render json: {productsPartial: render_to_string('home/_products', locals: {showFirst: false}), layout: false}
  end
end
