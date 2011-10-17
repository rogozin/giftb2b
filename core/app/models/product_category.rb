#encoding: utf-8;
class ProductCategory < ActiveRecord::Base
 belongs_to :product
 belongs_to :category, :touch => true
 set_primary_keys :product_id, :category_id
end
