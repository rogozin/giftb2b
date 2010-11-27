class ProductProperty < ActiveRecord::Base
  belongs_to :property_value
  belongs_to :product
end
