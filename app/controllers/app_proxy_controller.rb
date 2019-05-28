class AppProxyController < ApplicationController
   include ShopifyApp::AppProxyVerification

  def index
    if params[:search_on_query].present?
      render_search_on_bool
    elsif params[:filter].present?
      render_filtered_products
    elsif params[:search].present?
      render_searched_products
    else
      render_all_products
    end
  end

  private

  def render_search_on_bool
    render json: {search_on: ProductSetting.last.true_search_on}
  end

  def render_all_products
    @products = ProductFilter.new(product_params).filter(query_string)
    @products_count = ProductFilter.new(product_params).count_from_filter(query_string)
    @vendor_array = all_vendors_for_query
    @size_array = Filter.sizes.pluck(:title)
    @product_type = Filter.types.pluck(:title)
    @price_ranges = ['0 - 31', '31 - 70', '71 - 90', '91 - 110']
    render content_type: 'application/liquid'
  end

  def all_vendors_for_query
    return Filter.brands.pluck(:title) unless params[:query].present?
    vendors = []
    query_arr = params[:query].split(' ')
    query_arr.each do |arr|
      vendors << Product.where('lower(vendor) ~* ?', arr.downcase).pluck(:vendor).uniq
    end
    vendors.flatten.present? ? vendors.flatten : Filter.brands.pluck(:title)
  end

  def render_filtered_products
    page = params[:page]
    @products = ProductFilter.new(product_params).filter(query_string)
    @products_count = ProductFilter.new(product_params).count_from_filter(query_string)
    @products = [] if products_are_already_in_view?
    render json: {productsPartial: render_to_string('home/_products', locals: {showFirst: false},layout: false), productCount: @products.count, lastProductID: @products.last.try(:id)}
  end

  def render_searched_products
    @products = ProductFilter.new({title: query_string}).search
    @popular = ProductFilter.new({title: query_string}).popular
    render json: {searchPartial: render_to_string('home/_search_results', layout: false) }
  end

  def query_string
    synon = ProductSetting.last.product_synonyms.where('synonym = ?', params[:query]).first
    return params[:query] unless synon
    return synon.value
  end

  def product_params
    {limit: 36, title: params[:brand], product_type: params[:product_type], tag: params[:size], page: params[:page], price: params[:price], sort_by: params[:sort_by]}
  end

  def products_are_already_in_view?
    params[:last_prod_id].present? && params[:last_prod_id] == @products.last.id.to_s rescue false
  end

end
