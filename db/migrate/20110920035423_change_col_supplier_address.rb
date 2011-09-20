class ChangeColSupplierAddress < ActiveRecord::Migration
  def self.up
    change_column :suppliers, :address, :text
  end

  def self.down
     change_column :suppliers, :address, :string
  end
end
