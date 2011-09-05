#encoding: utf-8;
require 'spec_helper'

describe "Supplier" do

  it 'permalink' do
    s = Supplier.new(:name => "test")
    s.should be_valid
    s.permalink.should eq("test")
  end
  
  it "Деактивация всех товаров поставщика" do
       product1 = Factory(:product)
       product2 = Factory(:product, :supplier_id => product1.supplier_id)
       product1.supplier.deactivate_all_products
       Product.where({:active => false}).should have(2).records
  end
  
end
