#encoding: utf-8;
require 'spec_helper'

describe Product do
  
  subject { LkProduct.new(:price => nil)}
  it { should_not be_valid}
  it { should have(1).error_on(:price)}
  
  context 'Возможные варианты удаления товара' do
    before(:each) do
      @commercial_offer = Factory(:commercial_offer)
      @product = @commercial_offer.commercial_offer_items.first.lk_product
      @order = Factory(:lk_order)
      @order.lk_order_items.create(:product => @product, :quantity => 1, :price => 10)
      @commercial_offer.commercial_offer_items.create(:lk_product =>@product, :quantity => 1 )
    end
                
    it 'restrict когда товар есть в заказе' do       
      expect {@product.destroy}.should raise_error      
    end  
    
    it 'я не могу удалить товар если он есть в заказе или в КО' do
      @product.should_not be_can_destroy
    end
    
    it 'LkProduct should be destroyed after removing CommercialOfferItem from CO' do
      #Удаляю записи из заказа
      @order.lk_order_items.delete_all
      @product.toggle(:active)
      @commercial_offer.commercial_offer_items.each {|x| x.destroy}         
      @product.should be_can_destroy
      @product.should be_destroyed      
    end
      
  end
  
end
