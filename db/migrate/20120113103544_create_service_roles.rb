class CreateServiceRoles < ActiveRecord::Migration
  def change
    create_table :service_roles, :id => false, :force => true do |t|
      t.integer :service_id
      t.integer :role_id
    end
    add_index :service_roles, [:service_id, :role_id], :unique => true
  end
end
