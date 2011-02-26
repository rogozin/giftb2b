class CreateLkOrderLogs < ActiveRecord::Migration
  def self.up
    create_table :lk_order_logs do |t|
      t.integer :lk_order_id
      t.integer :status_id
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :lk_order_logs
  end
end
