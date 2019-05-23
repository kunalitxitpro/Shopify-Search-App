class ProductFilter

  def initialize(params)
    @params = params
  end

  def search
    products = Product
    @params[:title].split(' ').each do |query|
      products = products.where('lower(title) ~* ? OR lower(vendor) ~* ?', query.downcase, query.downcase)
    end
    if ProductSetting.last.overflow_scroll_on
      products.limit(50)
    else
      products.limit(5)
    end
  end

  def popular
    products = Product
    @params[:title].split(' ').each do |query|
      products = products.where('lower(title) ~* ? OR lower(vendor) ~* ?', query.downcase, query.downcase)
    end
    products.order(quantity: :asc).limit(8)
  end

  def filter(query = nil)
    return filter_for_search_query(query) if query.present?
    products = param_is_present? ? Product.joins(:sizes).where(sql_query).distinct : Product.joins(:sizes).distinct
    products = products.where('quantity > 0') unless ProductSetting.last.include_out_of_stock_products
    ordered_query(products)
  end

  def count_from_filter(query = nil)
    return filter_count_for_search(query) if query.present?
    products = param_is_present? ? Product.joins(:sizes).where(sql_query).distinct  : Product.joins(:sizes).distinct
    products = products.where('quantity > 0') unless ProductSetting.last.include_out_of_stock_products
    return products.count
  end

  private

  def filter_for_search_query(search)
    products = search_filter(search)
    ordered_query(products)
  end

  def filter_count_for_search(search)
    search_filter(search).count
  end

  def search_filter(search)
    products = Product
    search.split(' ').each do |query|
      products = products.where('lower(products.title) ~* ? OR lower(vendor) ~* ?', query.downcase, query.downcase)
    end
    products = param_is_present? ? products.joins(:sizes).where(sql_query).distinct : products.joins(:sizes).distinct
    products = products.where('quantity > 0') unless ProductSetting.last.include_out_of_stock_products
    return products
  end

  def sql_query
    sql_arr = []
    sql_arr << vendor_lookup if @params[:title].present?
    sql_arr << product_type if @params[:product_type].present?
    sql_arr << size_lookup if @params[:tag].present?
    sql_arr << price_lookup if @params[:price].present?
    sql_arr.join(" AND ")
  end

  def param_is_present?
    @params[:title].present? || @params[:product_type].present? || @params[:tag].present? || @params[:price].present?
  end

  def ordered_query(products)
    if @params[:sort_by] == 'title_descending'
      products.order(title: :desc).offset(offset_page).limit(items_to_load)
    elsif @params[:sort_by] == 'title_ascending'
      products.order(title: :asc).offset(offset_page).limit(items_to_load)
    elsif @params[:sort_by] == 'price_ascending'
      products.order(price: :asc).offset(offset_page).limit(items_to_load)
    elsif @params[:sort_by] == 'price_descending'
      products.order(price: :desc).offset(offset_page).limit(items_to_load)
    elsif @params[:sort_by] == 'created_ascending'
      products.order(shopify_created_at: :asc).offset(offset_page).limit(items_to_load)
    elsif @params[:sort_by] == 'created_descending'
      products.order(shopify_created_at: :desc).offset(offset_page).limit(items_to_load)
    else
      products.order(title: :asc).offset(offset_page).limit(items_to_load)
    end
  end

  def offset_page
    @params[:page].to_i * items_to_load
  end

  def vendor_lookup
    sql_arr = []
    @params[:title].each do |title|
      sql_arr << "vendor = '#{title}'"
    end
    sql_arr.join(" OR ")
  end

  def price_lookup
    prices = @params[:price].split('-')
    "price >= #{prices[0]} AND price <= #{prices[1]}"
  end

  def product_type
    sql_arr = []
    @params[:product_type].each do |title|
      sql_arr << "product_type = '#{title}'"
    end
    sql_arr.join(" OR ")
  end

  def items_to_load
    return items_to_load unless ProductSetting.last.number_of_items_to_load.present?
    ProductSetting.last.number_of_items_to_load
  end

  def size_lookup
    sql_arr = []
    @params[:tag].each do |tag|
      sql_arr << "sizes.title = '#{tag}'"
    end
    sql_arr.join(" OR ")
  end
end
