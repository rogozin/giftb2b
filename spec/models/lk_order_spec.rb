#encoding: utf-8;
require 'spec_helper'

describe LkOrder do
  
  it 'валидация email' do
    o = LkOrder.new(:firm_id => 1)
    o.should be_valid
    o.user_email = "32423fdsfasd.ru"
    o.should_not be_valid
    o.user_email = "32423fdsfasd@mail.gov"
    o.should be_valid
  end
  
  it 'контактный email' do
    @lk_order = Factory(:lk_order)
    @lk_order.lk_firm.email = "firm@demo.net"
    @lk_order.contact_email.should eq("firm@demo.net")
    @lk_order.user_email =  "user@demo.net"
    @lk_order.contact_email.should eq("user@demo.net")
  end
  
end
