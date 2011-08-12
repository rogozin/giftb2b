#encoding: utf-8;
class ProductProperty < ActiveRecord::Base
  set_primary_keys :property_value_id, :product_id
  belongs_to :property_value
  belongs_to :product
end
