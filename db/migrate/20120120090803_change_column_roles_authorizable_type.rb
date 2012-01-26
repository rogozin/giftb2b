class ChangeColumnRolesAuthorizableType < ActiveRecord::Migration
  def change
    change_column :roles, :authorizable_type, :string
  end
end
