#encoding: utf-8;
class Supplier < ActiveRecord::Base
  has_many :products, :dependent => :destroy
  has_many :stores, :dependent => :destroy
  validates :name, :uniqueness => true
  validates :permalink, :presence => true, :uniqueness => true
  before_validation :set_permalink
  after_create :create_default_store
  
  def deactivate_all_products
    Product.update_all({:active => false}, {:supplier_id => id})
  end
  
  
  private 
  
  def set_permalink
    self[:permalink] = name.parameterize unless self[:permalink]
  end
  
  def create_default_store
    stores.create(:name => "основной")    
  end
  
  
end
