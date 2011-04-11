class AddColsForBwAndSupplier < ActiveRecord::Migration
  def self.up
    add_column :suppliers, :allow_upload, :boolean, :default => true
    add_column :background_workers, :supplier_id, :integer
  end

  def self.down
    remove_column :suppliers, :allow_upload
    remove_column :background_workers, :supplier_id
  end
end
