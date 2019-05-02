class ProductFilter

  def initialize(params)
    @params = params
  end

  def search
    Product.where('lower(title) ~* ? OR lower(vendor) ~* ?', @params[:title].downcase,@params[:title].downcase).limit(50)
  end

  def popular
    Product.where('lower(title) ~* ? ', @params[:title]).order(quantity: :asc).limit(8)
  end

  def filter
    products = param_is_present? ? Product.where(sql_query) : Product
    products = products.where('quantity > 0') unless ProductSetting.last.include_out_of_stock_products
    ordered_query(products)
  end

  private

  def sql_query
    sql_arr = []
    sql_arr << vendor_lookup if @params[:title].present?
    sql_arr << product_type if @params[:product_type].present?
    sql_arr << size_lookup if @params[:tag].present?
    sql_arr.join(" AND ")
  end

  def param_is_present?
    @params[:title].present? || @params[:product_type].present? || @params[:tag].present?
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
      products.order(title: :asc).limit(items_to_load)
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
      sql_arr << "sizes LIKE '%#{tag}%'"
    end
    sql_arr.join(" OR ")
  end
end
