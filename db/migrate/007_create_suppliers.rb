class CreateSuppliers < ActiveRecord::Migration
  def self.up
    create_table :suppliers do |t|
      t.string :name, :limit => 80
      t.string :address
    end
  end

  def self.down
    drop_table :suppliers
  end
end
