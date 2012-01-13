class AddColumnSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :group_id, :integer
  end
end
