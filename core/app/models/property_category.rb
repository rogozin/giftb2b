#encoding: utf-8;
class PropertyCategory < ActiveRecord::Base
  belongs_to :property
  belongs_to :category
end
