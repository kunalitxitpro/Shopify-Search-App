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

  def shopify_params(for_variant = false)
    hash = {}
    hash.merge!(limit: params[:limit]) if params[:limit].present? && !for_variant
    hash.merge!(title: params[:title]) if params[:title].present?
    hash.merge!(product_type: params[:product_type]) if params[:product_type].present?
    hash.merge!(page: params[:page]) if params[:page].present? && !for_variant
    return hash
  end


  def variant_param_present?
    params[:tag].present?
  end


  def get_all_products_for_tag
    total_products = ShopifyAPI::Product.count()
    total_prods_to_loop = (total_products.to_f/250).round

    total_prods_to_loop.times do |page|
      break if @products.count >= 36
      page = page + 1
      products = ShopifyAPI::Product.find(:all, params: shopify_params(true).merge!({page: page, limit: 250})).select{|p| can_include_product?(p) }
      @products << products
      @products = @products.flatten.uniq
    end

    final_products = @products.flatten.uniq[page_for_variant, 36]
    return final_products.present? ? final_products : []
  end

  def page_for_variant
    return 0 unless params[:page].present?
    index = params[:page].to_i - 1
    index * 36
  end


  def can_include_product?(product)
    product.variants.map{|a| a.title}.include?(params[:tag])
  end
end
