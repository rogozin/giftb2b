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
  
  it 'active after create' do
    b = Banner.create(:firm_id => 1, :text => "КУПИТЕ СУВЕНИРЫ", :active => true, :position => 1)
    Banner.active(1).should have(1).record    
  end
  
  context "CACHING" do
    before(:each) do
      @b = Banner.create(:firm_id => 1, :text => "КУПИТЕ СУВЕНИРЫ1", :active => true, :position => 1)
    end

    it 'cached after create' do
      Banner.cached_active_banners(1).should have(1).record            
      Rails.cache.fetch("site/#{Settings.site_id}/active_banners/1").should have(1).items        
    end  
    
    it 'after deactivate cache should be nil' do
      @b.toggle! :active
      Rails.cache.fetch("site/#{Settings.site_id}/active_banners/1").should be_nil
      Banner.cached_active_banners(1).should be_empty
    end

    it 'after update text' do
      @b.update_attributes(:text => "AAA")
      Banner.cached_active_banners(1).should have(1).record
      Rails.cache.fetch("site/#{Settings.site_id}/active_banners/1").should eq [@b]
    end
    
    it 'after update position' do
      @b.update_attributes(:position =>  2)
      Rails.cache.fetch("site/#{Settings.site_id}/active_banners/2").should be_nil
      Banner.cached_active_banners(1).should be_empty      
    end
  
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
