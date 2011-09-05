#encoding: utf-8;
class Supplier < ActiveRecord::Base
  has_many :products
  validates :name, :uniqueness => true
  validates :permalink, :presence => true, :uniqueness => true
  before_validation :set_permalink
  
  def deactivate_all_products
    Product.update_all({:active => false}, {:supplier_id => id})
  end
  
  def to_param
    self[:permalink]
  end
  
  private 
  
  def set_permalink
    self[:permalink] = name.parameterize unless self[:permalink]
  end
end
