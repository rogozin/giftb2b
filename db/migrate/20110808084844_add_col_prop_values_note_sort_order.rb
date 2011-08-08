class AddColPropValuesNoteSortOrder < ActiveRecord::Migration
  def self.up
    add_column  :property_values, :note, :string, :lentht => 255 
  end

  def self.down
    remove_column :property_values, :note
  end
end
