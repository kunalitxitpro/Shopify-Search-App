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
            Product.create(
              title: prod.title,
              vendor: prod.vendor,
              tags: prod.tags,
              first_image_url: prod.image.src,
              second_image_url: prod.images.second.try(:src),
              price: prod.variants.first.price.to_f,
              compare_at_price: compare_price,
              sizes: prod.variants.map{|a| a.title}.join(', '),
              shopify_id: prod.id,
              product_type: prod.product_type
            )
          end
        end
      end
    end
  end
end
