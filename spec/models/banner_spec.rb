#encoding:utf-8;
require 'spec_helper'

describe Banner do
  it 'Новый баннер' do
    b = Banner.new(:firm_id => nil)
    b.active.should be_false
    b.type_id.should be_zero
    b.should_not be_valid
    b.should have(1).error_on(:firm_id)
  end


  it 'типы баннера' do
    b = Banner.new
    b.type.should == "HTML"
    b.type_id = 1
    b.type.should == "Image"
  end
  
  it 'кеш' do
    b = Banner.create(:firm_id => 1, :text => "КУПИТЕ СУВЕНИРЫ", :active => true)
    Banner.active.should have(1).record
    b1 = Banner.create(:firm_id => 1, :text => "КУПИТЕ СУВЕНИРЫ1", :active => true)
    Banner.cached_active_banners.should have(2).record
    b1.toggle! :active
    Banner.cached_active_banners.should have(1).record
  end
end
