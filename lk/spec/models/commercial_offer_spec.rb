#encoding: utf-8;
require 'spec_helper'

describe CommercialOffer do
  
  it 'Клиент может быть только из списка клиентов этой фирмы' do
    @lk_firm = Factory(:lk_firm)
    @co = CommercialOffer.new(:firm_id => 999, :lk_firm_id => 99)
    @co.should have(1).error_on(:lk_firm_id)
  end
  
end
