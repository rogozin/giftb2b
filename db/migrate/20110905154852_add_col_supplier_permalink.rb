class AddColSupplierPermalink < ActiveRecord::Migration
  def self.up
    add_column :suppliers, :permalink, :string, :null => false
    Supplier.all.each {|x| x.update_attribute(:permalink,  x.name.parameterize) }
    add_index :suppliers, :permalink, :unique => true
  end

  def self.down
    remove_column :suppliers, :permalink
  end
end
