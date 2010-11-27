class CreateCurrencyValues < ActiveRecord::Migration
  def self.up
    create_table :currency_values do |t|
      t.date :dt
      t.decimal :usd, :precision=>10, :scale => 2, :default => 0
      t.decimal :eur, :precision=>10, :scale => 2, :default => 0      
      t.timestamps
    end
  end

  def self.down
    drop_table :currency_values
  end
end
