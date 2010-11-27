class CreateBackgroundWorkers < ActiveRecord::Migration
  def self.up
    create_table :background_workers do |t|
      t.string :task_name 
      t.string :current_status
      t.integer :current_item, :default => 0
      t.integer :total_items, :default => 0
      t.integer :user_id, :not_null => true
      t.text :log_errors
      t.datetime :task_end      
      t.timestamps
    end
  end

  def self.down
    drop_table :background_workers
  end
end
