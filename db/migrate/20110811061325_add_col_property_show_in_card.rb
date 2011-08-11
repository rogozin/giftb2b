class AddColPropertyShowInCard < ActiveRecord::Migration
  def self.up
    add_column :properties, :show_in_card, :boolean, :default => false
  end

  def self.down
    remove_column :properties, :show_in_card
  end
end
