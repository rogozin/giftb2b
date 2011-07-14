class AddColSamplesClosed < ActiveRecord::Migration
  def self.up
    add_column :samples, :closed, :boolean, :default => false
  end

  def self.down
    remove_column :samples, :closed
  end
end
