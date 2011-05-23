class AddColsFirmCitySubway < ActiveRecord::Migration
  def self.up
    add_column :firms, :city, :string, :limit => 100
    add_column :firms, :subway, :string, :limit => 100
    add_index :firms, :city
  end

  def self.down
    remove_column :firms, :city
    remove_column :firms, :subway
  end
end
