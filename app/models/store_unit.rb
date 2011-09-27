class StoreUnit < ActiveRecord::Base
  set_primary_keys :store_id, :product_id
  belongs_to :store
  belongs_to :product, :touch => true
  validates :option,  :inclusion => { :in => -1..1 }
  validates_presence_of :store_id, :product_id
end
