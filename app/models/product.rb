class Product < ApplicationRecord
  validates :shopify_id, uniqueness: true

  def self.dedupe
    grouped = all.group_by{|model| [model.shopify_id] }
    grouped.values.each do |duplicates|
      first_one = duplicates.shift
      duplicates.each{|double| double.destroy}
    end
  end

  def display_price
    '%.2f' % price
  end

  def compare_at_display_price
    '%.2f' % compare_at_price
  end
end
