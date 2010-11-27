class CurrencyType < ActiveRecord::Migration
  def self.up
   add_column  :products, :currency_type, :string, :limit => 3
   add_column  :products, :meta_keywords, :string
   rename_column :products, :meta, :meta_description
  end

  def self.down
    remove_column :products, :currency_type
    remove_column :products, :meta_keywords
    rename_column :products, :meta_description, :meta
  end
end
