class AddColsFirmDescriptionLatLong < ActiveRecord::Migration
  def self.up
    add_column :firms, :description, :text
    add_column :firms, :lat, :double
    add_column :firms,  :long, :double
    add_column :firms,  :permalink, :string
    
  end

  def self.down
    remove_column :firms, :description, :lat, :long, :permalink
  end
end
