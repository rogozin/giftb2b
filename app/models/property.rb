#encoding: utf-8;
class Property < ActiveRecord::Base
  has_many :property_values, :dependent => :destroy
  has_many :property_category, :dependent => :delete_all
  has_many :categories, :through => :property_category
  
  def self.property_types
    [['Текст',0],['Ссылка на изобржение',1],['Гиперссылка',2],['Артикул товара',3]]
  end
  
  def property_type_text
   Property.property_types.find {|i| i.last == self.property_type }.first
  end
end
