class StoreUnit < ActiveRecord::Base
  set_primary_keys :store_id, :product_id
  belongs_to :store
  belongs_to :product, :touch => true
end
