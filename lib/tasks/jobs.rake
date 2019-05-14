namespace :jobs do
  desc "Add all shopify products"
  task add_and_update_products: :environment do
    shop = Shop.last
    if shop.present?
      shop.with_shopify_session do
        total_products = ShopifyAPI::Product.count()
        total_prods_to_loop = (total_products.to_f/250).round

        total_prods_to_loop.times do |page|
          page = page + 1
          products = ShopifyAPI::Product.find(:all, params: {page: page, limit: 250})

          products.each do |prod|
            compare_price = prod.variants.first.compare_at_price.to_f rescue nil
            set_prod = Product.where(shopify_id: prod.id).first
            new_prod = set_prod.present? ?  update_product(prod, compare_price, set_prod) : new_product(prod, compare_price)
            new_prod.save
            add_sizes(prod, new_prod)
          end
        end
      end
    end
  end

  def new_product(prod, compare_price)
    Product.new(
      title: prod.title,
      vendor: prod.vendor,
      tags: prod.tags,
      first_image_url: prod.image.src,
      second_image_url: prod.images.second.try(:src),
      price: prod.variants.first.price.to_f,
      quantity: prod.variants.first.inventory_quantity,
      compare_at_price: compare_price,
      shopify_id: prod.id,
      product_type: prod.product_type,
      shopify_created_at: prod.created_at.to_datetime,
      slug_url: prod.handle
    )
  end

  def update_product(prod, compare_price, set_product_record)
    set_product_record.title = prod.title
    set_product_record.vendor = prod.vendor
    set_product_record.tags = prod.tags
    set_product_record.first_image_url = prod.image.src
    set_product_record.second_image_url = prod.images.second.try(:src)
    set_product_record.price = prod.variants.first.price.to_f
    set_product_record.quantity = prod.variants.first.inventory_quantity
    set_product_record.compare_at_price = compare_price
    set_product_record.product_type =  prod.product_type
    set_product_record.shopify_created_at = prod.created_at.to_datetime
    set_product_record.slug_url =  prod.handle
    return set_product_record
  end

  def add_sizes(product, record)
    product.variants.each do |size|
      newsize = Size.find_or_create_by(shopify_id: size.id)
      newsize.title = size.title
      newsize.inventory_quantity = size.inventory_quantity
      newsize.product_id = record.id
      newsize.save
    end
  end
end
