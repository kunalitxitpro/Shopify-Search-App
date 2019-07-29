class ShopifyApiConnector

  def initialize()
    @connection = set_connection
  end

  def refresh_collections
    Collection.destroy_all
    CollectionRule.destroy_all

    collections = get_smart_collections
    collections.each do |collection|
      if collection['published_at'].present?
        coll = Collection.new(title: collection['title'], handle: collection['handle'], sort_order: collection['sort_order'])
        coll.save

        collection['rules'].each do |rule_hash|
          rule = CollectionRule.new(collection_id: coll.id, search_attribute: rule_hash['column'], rule_identifier: rule_hash['relation'], condition: rule_hash['condition'])
          rule.save
        end
      end
    end
  end

  private

  def get_smart_collections
    response = @connection.get 'https://truevintageclothing.myshopify.com/admin/api/2019-07/smart_collections.json?limit=250'
    body = JSON.parse(response.body)
    body['smart_collections']
  end

  def set_connection
    conn = Faraday.new
    conn.basic_auth(ENV['SHOP_API_USERNAME'], ENV['SHOP_API_PASSWORD'])
    conn
  end
end
