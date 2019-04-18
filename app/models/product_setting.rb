class ProductSetting < ApplicationRecord
  mount_uploader :image, LoaderUploader
end
