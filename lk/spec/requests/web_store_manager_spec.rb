#encoding: utf-8;
require 'spec_helper'


describe 'Роль Интернет-магазин' do
  before(:each) do
     login_as :web_store_manager
     @firm = Factory(:firm)
     @user.update_attributes(:firm => @firm, :fio => "Петр Иванов")    
  end
  
  context "Личный кабинет" do
  
  it 'видимость пунктов меню' do
    visit "/lk"
    page.should have_selector "#user_menu a", :count => 3     
    within "#user_menu" do
      page.should have_content "Список заказов"
      page.should have_content "Клиенты"
      page.should have_content "Список товаров"
    end
  end
  
  it 'навигация' do
    visit "/lk"
    click_link "Список заказов"
    save_and_open_page
    click_link "Клиенты"
    save_and_open_page
    click_link "Список товаров"
    save_and_open_page        
  end
  
  end
  
end
