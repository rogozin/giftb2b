#encoding: utf-8;
class ProductCategory < ActiveRecord::Base
 belongs_to :product
 belongs_to :category
end
