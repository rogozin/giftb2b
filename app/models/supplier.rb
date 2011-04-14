class Supplier < ActiveRecord::Base
  has_many :products
  validates :name, :uniqueness => true
  
  def deactivate_all_products
    Product.update_all({:active => false}, {:supplier_id => self.id})
  end
end
