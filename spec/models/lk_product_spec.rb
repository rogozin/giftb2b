#encoding: utf-8;
require 'spec_helper'

describe Product do
  
  subject { LkProduct.new(:price => nil)}
  it { should_not be_valid}
  it { should have(1).error_on(:price)}
  
  it 'restrict при удалении товара из ко, когда тот используется в заказе' do
    @product = Factory(:lk_product)
    @commercial_offer = Factory(:commercial_offer)
    @order = Factory(:lk_order)
    @order.lk_order_items.create(:product => @product, :quantity => 1, :price => 10)
    @commercial_offer.commercial_offer_items.create(:lk_product =>@product, :quantity => 1 )
    expect {@product.destroy}.should raise_error
  end
  
end
