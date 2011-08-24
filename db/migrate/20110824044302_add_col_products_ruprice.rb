class AddColProductsRuprice < ActiveRecord::Migration
  def self.up
    add_column :products, :ruprice, :decimal, :precision=>10, :scale => 2, :default => 0    
    Product.update_all( ["ruprice = price * ?", CurrencyValue.kurs("EUR")], "currency_type='EUR'")
    Product.update_all( ["ruprice = price * ?", CurrencyValue.kurs("USD")], "currency_type='USD'")
    Product.update_all( "ruprice = price", "currency_type='RUB'")
   end

  def self.down
    remove_column :products, :ruprice    
  end
end
