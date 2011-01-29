class CreateLkOrders < ActiveRecord::Migration
  def self.up
    create_table :lk_orders do |t|
      t.integer :firm_id
      t.integer :lk_firm_id
      t.integer :status_id, :default => 0
      t.string :random_link
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :lk_orders
  end
end
