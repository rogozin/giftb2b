class AddColStoreUnitsOption < ActiveRecord::Migration
  def self.up
    add_column :store_units, :option, :integer, :default => 1
  end

  def self.down
    remove_column :store_units, :option
  end
end
