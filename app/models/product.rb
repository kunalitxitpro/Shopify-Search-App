class Product < ApplicationRecord
  validates :shopify_id, uniqueness: true
end
