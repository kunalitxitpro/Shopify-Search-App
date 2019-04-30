class ProductSetting < ApplicationRecord
  mount_uploader :image, LoaderUploader

  def filter_array
    filter_order.split(',')
  end
end
