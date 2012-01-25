#encoding: utf-8;
require 'spec_helper'


describe 'Роль Интернет-магазин' do
  
  before(:each) do
     login_as :user
     @user.role_objects << Factory(:r_orders)
     @user.role_objects << Factory(:r_clients)
     @user.role_objects << Factory(:r_products)
     @firm = Factory(:firm)
     @user.update_attributes(:firm => @firm, :fio => "Петр Иванов")    
     Factory(:color_property, :name => "Цвет", :property_values => [PropertyValue.create(:value => "красный")])
     Settings.stub(:giftpoisk?).and_return(true)     
  end
  
  context 'главная страница' do
    it 'не вижу корзину' do
      visit "/lk"
      page.should have_no_selector "#cart"
    end      
  end
  
  context "расширенный поиск" do
    it 'доступен поиск по артикулу и названию' do
      visit "/lk"
      within "#ext_search" do
        page.should have_selector "#name"      
        page.should have_selector "#store_from"      
        page.should have_selector "#price_from"      
        page.should have_selector "#price_to"      
        page.should have_selector ".color-box"      
        page.should have_no_selector "#article"      
        page.should have_no_selector "#manufactor_id"      
        page.should have_no_selector ".suppliers-items"      
        page.should have_no_selector ".material-items"      
      end
    end
  end
  
  context "Личный кабинет" do
  
  it 'видимость пунктов меню' do
    visit "/lk"
    page.should have_selector "#user_menu a", :count => 3     
    within "#user_menu" do
      page.should have_content "Поступившие заказы"
      page.should have_content "Клиенты"
      page.should have_content "Моя база сувениров"
    end
  end
  
  it 'навигация' do
    visit "/lk"
    click_link "Поступившие заказы"
    click_link "Клиенты"
    click_link "Моя база сувениров"
  end
  
  end
  
end
