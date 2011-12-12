#encoding: utf-8;
require 'spec_helper'

describe CommercialOfferItem do
  
  it 'Скидка в пределах 0..99 для новой записи' do
    @co = CommercialOfferItem.new(:commercial_offer_id => 999, :quantity => 1, :lk_product_id => 1, :sale => 111)
    @co.should have(1).error_on(:sale)
  end
  
end
