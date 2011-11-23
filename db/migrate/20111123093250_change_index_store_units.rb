class ChangeIndexStoreUnits < ActiveRecord::Migration
  def change
   remove_index  :store_units, [:store_id, :product_id]
   add_index  :store_units, [:store_id, :product_id, :option], :unique => true
  end
end
