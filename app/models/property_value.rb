#encoding: utf-8;
class PropertyValue < ActiveRecord::Base
  belongs_to :property
  has_many :product_properties, :dependent => :delete_all
  has_many :products, :through => :product_properties
  #default_scope :joins => :property, :select => "property_values.*, properties.name property_name"
  
 # named_scope :for_display, :joins => :property, :select => "property_values.*, properties.name property_name"
  
end
