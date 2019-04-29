class ProductFilter

  def initialize(params)
    @params = params
  end

  def search
    products = param_is_present? ? Product.where(sql_query) : Product.limit(36)
    # ordered_query(products)
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
    return products if param_is_present?
    if @params[:sort_by] == 'title_descending'
      products.order(title: :desc).offset(offset_page).limit(items_to_load)
    elsif @params[:sort_by] == 'title_ascending'
      products.order(title: :asc).offset(offset_page).limit(items_to_load)
    elsif @params[:sort_by] == 'price_ascending'
      products.order(price: :asc).offset(offset_page).limit(items_to_load)
    elsif @params[:sort_by] == 'price_descending'
      products.order(price: :desc).offset(offset_page).limit(items_to_load)
    elsif @params[:sort_by] == 'created_ascending'
    elsif @params[:sort_by] == 'created_descending'
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
