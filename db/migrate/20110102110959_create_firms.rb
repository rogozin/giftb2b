class CreateFirms < ActiveRecord::Migration
  def self.up
    create_table :firms do |t|
      t.string :name
      t.string :short_name
      t.text :addr_u
      t.text :addr_f
      t.string :phone, :size => 100
      t.string :email, :size => 40
      t.string :url, :size => 40
      t.boolean :is_supplier, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :firms
  end
end
