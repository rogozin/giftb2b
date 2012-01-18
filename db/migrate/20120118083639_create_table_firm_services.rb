class CreateTableFirmServices < ActiveRecord::Migration
  def change
    create_table :firm_services, :id => false do |t|
      t.integer :firm_id
      t.integer :service_id
      t.datetime :created_at
      t.datetime :deleted_at
    end
    add_index :firm_services, [:firm_id, :service_id], :unique => true
  end
end
