class Product < ApplicationRecord
  validates :shopify_id, uniqueness: true
  has_many :sizes, dependent: :destroy

  def self.dedupe
    grouped = all.group_by{|model| [model.shopify_id] }
    grouped.values.each do |duplicates|
      first_one = duplicates.shift
      duplicates.each{|double| double.destroy}
    end
  end

  def first_image_url
    return super if super.nil?
    super.gsub(".jpg", "_700x.jpg")
  end

  def second_image_url
    return super if super.nil?
    super.gsub(".jpg", "_700x.jpg")
  end

  def display_price
    return '%.2f' % (price - (20.to_f/100.to_f * price)) if falls_under_discount
    '%.2f' % price
  end

  def compare_at_price
    return price if falls_under_discount
    super
  end

  def compare_at_display_price
    return '%.2f' % price if falls_under_discount
    '%.2f' % compare_at_price
  end

  private

  def falls_under_discount
    vendor != 'Stone Island' && vendor != 'Supreme' && vendor != 'Palace'
  end
end
