#encoding: utf-8;
class PropertyCategory < ActiveRecord::Base
  belongs_to :property
  belongs_to :category
  set_primary_keys :property_id, :category_id
end
