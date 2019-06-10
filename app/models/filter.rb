class Filter < ApplicationRecord
  belongs_to :product_setting
  validates :title, uniqueness: true

  scope :brands,  -> { where('filter_type = 0 AND (position IS NULL OR position != -1)').order(position: :asc )}
  scope :sizes,   -> { where('filter_type = 1 AND (position IS NULL OR position != -1)').order(position: :asc )}
  scope :types,   -> { where('filter_type = 2 AND (position IS NULL OR position != -1)').order(position: :asc )}
  scope :colours, -> { where('filter_type = 3 AND (position IS NULL OR position != -1)').order(position: :asc )}

  scope :admin_brands,  -> { where('filter_type = 0').order(position: :asc )}
  scope :admin_sizes,   -> { where('filter_type = 1').order(position: :asc )}
  scope :admin_types,   -> { where('filter_type = 2').order(position: :asc )}
  scope :admin_colours, -> { where('filter_type = 3').order(position: :asc )}

  enum filter_type: {
    prod_brand: 0,
    prod_size: 1,
    prod_type: 2,
    prod_colour: 3
  }

end
