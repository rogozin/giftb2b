#encoding: utf-8;
require 'spec_helper'

describe StoreUnit do
  it 'validate' do
    su = StoreUnit.new(:option => 4)
    su.should_not be_valid
    su.should have(1).error_on(:product_id)
    su.should have(1).error_on(:store_id)
    su.should have(1).error_on(:option)
  end
  
  
  describe "reset option" do 
    it "when count is null" do
      su = StoreUnit.create(:option => 1, :product_id => 1, :store_id => 1, :count => nil)
      su.should be_persisted
      su.option.should be_zero
    end
    
    it 'when count is zero' do
      su = StoreUnit.create(:option => 1, :product_id => 1, :store_id => 1, :count => 0)    
      su.should be_persisted
      su.option.should be_zero      
    end
    
    it 'when count is zero and option is -1' do
      su = StoreUnit.create(:option => -1, :product_id => 1, :store_id => 1, :count => 0)    
      su.should be_persisted
      su.option.should eq -1
    end    
    
  end
  
  describe "ограничения на кол-во записей" do
    before(:each) do
      StoreUnit.create(:option => 1, :product_id => 1, :store_id => 1, :count => 10)
      StoreUnit.create(:option => 2, :product_id => 1, :store_id => 1, :count => 5)
      StoreUnit.create(:option => 3, :product_id => 1, :store_id => 1, :count => 500)
    end

    
    it "Может быть только одна запись с option -1, 0, 1" do
      su =StoreUnit.create(:option => -1, :product_id => 1, :store_id => 1, :count => 10)
      StoreUnit.all.should have(3).records
      su.should be_persisted
    end
    
    it "Может быть только одна запись с option =2" do
      su = StoreUnit.create(:option => 2, :product_id => 1, :store_id => 1, :count => 7)
      StoreUnit.all.should have(3).records
      su.should be_persisted
    end
    
    it "Может быть только одна запись с option = 3" do
      su = StoreUnit.create(:option => 3, :product_id => 1, :store_id => 1, :count => 100)
      StoreUnit.all.should have(3).records
      su.should be_persisted      
    end

    
  end
  
end
