class AddColSupplierTerms < ActiveRecord::Migration
  def self.up
    add_column :suppliers, :terms, :text
  end

  def self.down
    remove_column :supplier, :terms
  end
end
