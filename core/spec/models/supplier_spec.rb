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
  
  it 'после создания поставщика ему назначается основной склад' do
    s = Supplier.new(:name =>"Поставщик-1")
    s.save
    s.stores.should have(1).record
    s.stores.first.name.should eq "основной"
  end
  
  it 'после удаления поставщика удаляются все склады' do
    s = Factory(:supplier)
    s.destroy
    s.should be_destroyed
    Store.where(:supplier_id => s.id).should be_empty
  end
    
end
