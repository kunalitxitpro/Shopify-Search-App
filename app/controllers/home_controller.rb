# frozen_string_literal: true

class HomeController < AuthenticatedController
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 36 })
    # @products = ProductSearch.new({ limit: 36, tag: 'for_guys', title: 'Adidas' }).search
    @webhooks = ShopifyAPI::Webhook.find(:all)
    @vendor_array = ['Adidas', 'American Sports Teams','Aquascutum','Armani','Asics', 'Avirex', 'Barbour', 'Belstaff', 'Best Company', 'Burberry']
    @size_array = ['L', 'M', 'S', "Women's", 'XL', 'XS', 'XXL', 'XXS']
    @product_type = ['Bags', 'dress', 'Football shirts', 'Hockey Top', 'Jackets & Coats', 'Jeans', 'Party Shirts', 'Polo Shirts', 'Rugby Tops', 'Shirts', 'Shorts', 'Skirts', 'Sweatshirts & Hoods', 'T-Shirts', 'Tracksuit', 'Tracksuit Bottoms', 'Trainers', 'Vests', 'Wholesale']
  end

  def products
    page = params[:page]
    @products = ShopifyAPI::Product.find(:all, params: { limit: 36, page: page })
    render json: {productsPartial: render_to_string('home/_products', locals: {showFirst: false}), layout: false}
  end
end
