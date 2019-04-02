# frozen_string_literal: true

class HomeController < AuthenticatedController
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 20 })
    @webhooks = ShopifyAPI::Webhook.find(:all)
  end
end
