class CreateTableFirmServices < ActiveRecord::Migration
  def change
    create_table :firm_services  do |t|
      t.integer :firm_id
      t.integer :service_id
      t.datetime :created_at
      t.datetime :deleted_at
    end
  end
end
