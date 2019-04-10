class ProductSearch

  def initialize(params)
    @params = params
    @products = []
  end

  def search
    return get_all_products_for_tag if variant_param_present?
    ShopifyAPI::Product.find(:all, params: shopify_params)
  end

  private

  attr_reader :params

  def shopify_params
    hash = {}
    hash.merge!(limit: params[:limit]) if params[:limit].present?
    hash.merge!(title: params[:title]) if params[:title].present?
    hash.merge!(product_type: params[:product_type]) if params[:product_type].present?
    return hash
  end


  def variant_param_present?
    params[:tag].present?
  end


  def get_all_products_for_tag
    total_products = ShopifyAPI::Product.count()
    total_prods_to_loop = (total_products.to_f/250).round

    total_prods_to_loop.times do |page|
      puts "Logger count is #{@products.count}"
      break if @products.count >= 36
      page = page + 1
      products = ShopifyAPI::Product.find(:all, {page: page, limit: 250}).select{|p| p.tags.include?(params[:tag])}
      @products << products
      @products = @products.flatten.uniq.first(36)
    end

    return @products
  end
end
