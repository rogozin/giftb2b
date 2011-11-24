class AddColStoreItemsCreatedAt < ActiveRecord::Migration
  def change
    add_column :store_units, :created_at, :datetime
  end
end
