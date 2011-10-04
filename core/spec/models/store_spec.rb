#encoding: utf-8;
require 'spec_helper'

describe Store do
  it 'validation' do
    s = Store.new
    s.should_not be_valid
    s.should have(1).error_on(:supplier_id)
    s.should have(1).error_on(:name)
  end
  
  
  it 'нельзя удалить если это единственный склад у поставщика' do
    sup = Factory(:supplier)
    sup.stores.first.destroy
    Store.all.should have(1).record
    sup.stores.create(:name => "дополнительный")
    sup.stores.first.destroy
    Store.all.should have(1).record
  end
  
  it 'после удаления склада удаляется информация о наличии на складе' do
     sup = Factory(:supplier)
     sup.stores.first.store_units.create(:product_id => 1, :count => 23)
     sup.destroy
     StoreUnit.all.should be_empty
  end
  
end
