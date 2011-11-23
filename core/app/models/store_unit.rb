#encoding: utf-8;
class StoreUnit < ActiveRecord::Base
  set_primary_keys :store_id, :product_id, :option
  belongs_to :store
  belongs_to :product, :touch => true
  validates :option,  :inclusion => { :in => -1..3 }
  validates_presence_of :store_id, :product_id
  before_save :null_value_protection
  before_create :unique_options
  
  private
  def null_value_protection
    self.option=0 if self.count.nil?
  end
  
  
  def unique_options
    su = StoreUnit.where(:store_id => self.store_id, :product_id => self.product_id)
    case self.option
      when -1,0,1
        su.delete_all(:option => [-1,0,1])
      else
       su.delete_all(:option => self.option)
     end
  end
  
  
  
end
