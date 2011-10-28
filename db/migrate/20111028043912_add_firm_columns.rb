class AddFirmColumns < ActiveRecord::Migration
  def up
    add_column :firms, :comment, :text
    add_column :firms, :phone2, :string
    add_column :firms, :phone3, :string
    add_column :firms, :email2, :string
  end

  def down
    remove_column :firms, :comment
    remove_column :firms, :phone2
    remove_column :firms, :phone3
    remove_column :firms, :email2
  end
end
