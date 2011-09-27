class Store < ActiveRecord::Base
  belongs_to :supplier
  has_many :store_units, :dependent => :delete_all
  has_many :products, :through => :store_units
  validates :supplier_id, :presence => true
  validates :name, :presence => true
  
  before_destroy :check_supplier_stores
  
  
  
  private
  
  def check_supplier_stores
     self.supplier.stores.size > 1
  end
end
