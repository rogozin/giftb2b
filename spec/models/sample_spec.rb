#encoding: utf-8;
require 'spec_helper'

describe Sample do
  it 'название не может быть пустым' do
    s=Sample.new
    s.should_not be_valid
    s.should have(1).error_on(:name)
    s.should have(1).error_on(:supplier_id)
    s.should have(1).error_on(:firm_id)
    s.should have(1).error_on(:user_id)
  end
  
  
  it 'дата покупки у поставщика не м.б. больше даты продажи клиенту' do
    s = Factory.build(:sample, :sale_date => Date.today - 2.days)
    s.should_not be_valid
    s.should have(1).error_on(:sale_date)
  end
  
  it 'дата возврата поставщику не может быть меньше даты возврата от клиента' do
    s = Factory.build(:sample, :client_return_date => Date.today + 4.days)
    s.should_not be_valid
    s.should have(1).error_on(:client_return_date)    
  end
  
  it 'цена покупки или продажи не может быть меньше 0' do
    s = Factory.build(:sample, :buy_price => -1, :sale_price => -1)
    s.should_not be_valid
    s.should have(1).error_on(:buy_price)
    s.should have(1).error_on(:sale_price)
  end
  
end
