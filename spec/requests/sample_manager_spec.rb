#encoding: utf-8;
require 'spec_helper'

describe 'i am sample_manager' do
  before(:each) do
    login_as :sample_manager
  end
  
  it "я вижу ссылку Образцы" do
      visit "/admin"
      within "#admin-menu" do
        page.should have_content("Образцы")
      end
      visit '/admin/samples'
      page.should have_content "Учет образцов"
  end
  
  it 'я могу добавить образец' do
    @firm = Factory(:firm)
    Factory(:supplier)
    visit '/admin/samples'
    click_link "Новая запись"
    fill_in "sample_name", :with => "Мой первый образец"
    select "Supplier 1", :from => "sample_supplier_id"
    fill_in "sample_buy_date", :with => Date.today
    fill_in "sample_buy_price", :with => 100
    fill_in "sample_supplier_return_date", :with => Date.today + 3.days
    select @firm.short_name, :from => "sample_firm_id"
    fill_in "sample_sale_date", :with => Date.tomorrow
    fill_in "sample_sale_price", :with => 200
    fill_in "sample_client_return_date", :with => Date.today + 2.days
    click_button "Сохранить"
    
    page.should have_content "Образец создан"
    page.should have_content "Редактирование записи"  
    click_link "Назад к списку образцов"    
    page.should have_content "Мой первый образец"
    
    within "#samples_list" do
      click_link 'Edit'
    end  
    page.should have_content "Редактирование записи"  
    fill_in "sample_name", :with => "Мой второй образец"
    click_button "Сохранить"    
    click_link "Назад к списку образцов"
    page.should have_content "Мой второй образец"
    
    within "#samples_list" do
      click_link 'Bin'
    end      
    page.should have_content "Образец удален"
  end
  
  it 'will_paginate' do
    40.times { Factory(:sample)}
    visit "/admin/samples"
    page.should have_selector "table tr", :count => 31
    within ".pagination" do 
      click_link "2"
    end
    page.should have_selector "table tr", :count => 11
  end
  
  it 'фильтр' do
    @sample = Factory(:sample, :name => "Карандаш")
    @sample2 = Factory(:sample, :name => "ручка")
    visit "/admin/samples"
    fill_in "name", :with => "Руч"
    click_button "Применить"  
    page.should have_selector "table tr", :count => 2    
  end
  
  context 'работа с фирмами' do
    before(:each) do
       @sample = Factory(:sample)
      visit edit_admin_sample_path(@sample)
    end

    it 'я могу добавить фирму' do
      click_link "add_firm_link"
      fill_in "firm_name", :with => "OOO Firma"
      fill_in "firm_short_name", :with => "FirmA"
      click_button "Сохранить"
      page.should have_content "Новая фирма успешно создана"
      page.should have_select "sample_firm_id", :options => [@sample.firm.short_name, "FirmA"]    
    end
  
    it 'я могу отредактировать фирму' do
      click_link "edit_firm_link"
      fill_in "firm_short_name", :with => "Рога без копыт"
      click_button "Сохранить"                
      page.should have_content "Атрибуты фирмы изменены"
      page.should have_select "sample_firm_id", :options => ["Рога без копыт"]          
    end
  end
end

