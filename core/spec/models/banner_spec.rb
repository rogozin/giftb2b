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
    b = Banner.create(:firm_id => 1, :text => "КУПИТЕ СУВЕНИРЫ", :active => true, :position => 1)
    Banner.active(1).should have(1).record
    b1 = Banner.create(:firm_id => 1, :text => "КУПИТЕ СУВЕНИРЫ1", :active => true, :position => 1)
    Banner.cached_active_banners(1).should have(2).record            
    Rails.cache.fetch("site/#{Settings.site_id}/active_banners/1").should have(2).items        
    b1.toggle! :active
    Rails.cache.fetch("site/#{Settings.site_id}/active_banners/1").should be_nil
    Banner.cached_active_banners(1).should have(1).record
    b1.update_attribute(:position, 2)
    Rails.cache.fetch("site/#{Settings.site_id}/active_banners/2").should be_nil
  end
  
  it 'show_on_page' do
    b = Banner.new(:firm_id => 1, :text => "КУПИТЕ СУВЕНИРЫ", :active => true, :position => 1, :pages => "/categories/ruchki; /categories/brelki")
    b.show_on_page?("/categories/ruchki").should be_true
    b.show_on_page?("/categories/ruchki?page=1").should be_true
    b.show_on_page?("/categories/plastik").should be_false
    b.pages = nil    
    b.should be_show_on_page
    b.pages = "/; /products/ruchka"
    b.show_on_page?("/").should be_true
    b.show_on_page?("/categories/1-plastik").should be_false
  end
  
  
  
end
