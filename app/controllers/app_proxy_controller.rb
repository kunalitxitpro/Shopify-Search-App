class AppProxyController < ApplicationController
   include ShopifyApp::AppProxyVerification

  def index
    # @products = ProductSearch.new(product_params).search
    if params[:filter].present?
      render_filtered_products
    elsif params[:search].present?
      render_searched_products
    else
      render_all_products
    end
  end

  private

  def render_all_products
    shop = Shop.find_by(shopify_domain: params[:shop])
    @products = ProductSearch.new(product_params, shop).search
    @vendor_array = ['Adidas', 'American Sports Teams','Aquascutum','Armani','Asics', 'Avirex', 'Barbour', 'Belstaff', 'Best Company', 'Burberry', 'Nike']
    @size_array = ['L', 'M', 'S', "Women's", 'XL', 'XS', 'XXL', 'XXS']
    @product_type = ['Bags', 'dress', 'Football shirts', 'Hockey Top', 'Jackets & Coats', 'Jeans', 'Party Shirts', 'Polo Shirts', 'Rugby Tops', 'Shirts', 'Shorts', 'Skirts', 'Sweatshirts & Hoods', 'T-Shirts', 'Tracksuit', 'Tracksuit Bottoms', 'Trainers', 'Vests', 'Wholesale']
    @price_ranges = ['0 - 31', '31 - 70', '71 - 90', '91 - 110']
    render content_type: 'application/liquid'
  end

  def render_filtered_products
    shop = Shop.find_by(shopify_domain: params[:shop])
    page = params[:page]
    @products = ProductSearch.new(product_params, shop).search
    @products = [] if products_are_already_in_view?
    render json: {productsPartial: render_to_string('home/_products', locals: {showFirst: false}), layout: false, productCount: @products.count, lastProductID: @products.last.try(:id)}
  end

  def render_searched_products
    shop = Shop.find_by(shopify_domain: params[:shop])
    if shop
      shop.with_shopify_session do
        query = params[:query]
        @products = ShopifyAPI::Product.find(:all, params: {title: query, limit: 36})
        render json: {searchPartial: render_to_string('home/_search_results', layout: false) }
      end
    end
  end

  def product_params
    {limit: 36, title: params[:brand], product_type: params[:product_type], tag: params[:size], page: params[:page], price: params[:price], sort_by: params[:sort_by]}
  end

  def products_are_already_in_view?
    params[:last_prod_id].present? && params[:last_prod_id] == @products.last.id.to_s rescue false
  end

end
