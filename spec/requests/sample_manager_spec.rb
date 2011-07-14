#encoding: utf-8;
require 'spec_helper'

describe 'Роль учет образцов' do
  before(:each) do
    login_as :sample_manager
    @firm = Factory(:firm)
    @user.update_attributes(:firm => @firm, :fio => "Петя")    
    @lk_firm = Factory(:lk_firm, :firm_id => @firm.id)    
  end
  
  it "я вижу ссылку Образцы" do
      visit "/lk"
      within "#user_menu" do
        page.should have_content("Образцы")
      end
      visit '/lk/samples'
      page.should have_content "Учет образцов"
  end
  
  it 'я могу добавить образец' do
    Factory(:supplier)
    visit '/lk/samples'
    click_link "Новая запись"
    fill_in "sample_name", :with => "Мой первый образец"
    select @user.fio, :from => "sample_responsible_id"
    select "Supplier 1", :from => "sample_supplier_id"
    fill_in "sample_buy_date", :with => Date.today
    fill_in "sample_buy_price", :with => 100
    fill_in "sample_supplier_return_date", :with => Date.today + 3
    select @lk_firm.name, :from => "sample_firm_id"
    fill_in "sample_sale_date", :with => Date.tomorrow
    fill_in "sample_sale_price", :with => 200
    fill_in "sample_client_return_date", :with => Date.today + 2
    click_button "Сохранить"
    
    page.should have_content "Образец создан"
    page.should have_content "Редактирование записи"  
    click_link "Назад к списку образцов"    
    page.should have_content "Мой первый образец"
    
    within "#samples_list" do
      click_link 'Edit'
    end  
    page.should have_content "Редактирование записи"  
    #обычный пользователь не видит галку закрывающую образец"
    page.should have_no_selector "#sample_closed"
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
    visit "/lk/samples"
    page.should have_selector "table tr", :count => 31
    within ".pagination" do 
      click_link "2"
    end
    page.should have_selector "table tr", :count => 11
  end
  
  it 'фильтр' do
    @sample = Factory(:sample, :name => "Карандаш")
    @sample2 = Factory(:sample, :name => "ручка")
    visit "/lk/samples"
    fill_in "name", :with => "Руч"
    click_button "Применить"  
    page.should have_selector "table tr", :count => 2    
  end
  
  it 'если не указаны даты, то все рабоатет' do    
    @sample = Factory(:sample, :buy_date => nil, :client_return_date => nil, :supplier_return_date => nil, :sale_date => nil)
    visit lk_samples_path
    page.should have_content @sample.name
  end
  
  context 'Признак возврата денег(закрытый образец)' do
    before(:each) do
      @sample = Factory(:sample, :closed => true)
    end
    
    it 'роль учет образцов не может отредактировать закрытый образец' do
      visit lk_samples_path
      page.should have_content @sample.name
      within "#samples_list" do
        page.should have_no_link "Edit"
        page.should have_no_link "Bin"
        page.should have_css "table tr.disabled-row"
      end
      visit edit_lk_sample_path(@sample)
      page.current_path.should == lk_samples_path
      page.should have_content "Нет доступа. Образец закрыт."
    end
    
  end
  
  context 'работа с фирмами' do
    before(:each) do
       @sample = Factory(:sample)
      visit edit_lk_sample_path(@sample)
    end

    it 'я могу добавить фирму' do
      click_link "add_firm_link"
      fill_in "lk_firm_name", :with => "OOO Firma"
      fill_in "lk_firm_contact", :with => "Вася"
      click_button "Сохранить"
      page.should have_content "Фирма создана"
      page.should have_select "sample_firm_id", :options => [@sample.lk_firm.name, "OOO Firma"]    
    end
  
    it 'я могу отредактировать фирму' do
      click_link "edit_firm_link"
      fill_in "lk_firm_name", :with => "Рога без копыт"
      click_button "Сохранить"                
      page.should have_content "Фирма изменена"
      page.should have_select "sample_firm_id", :options => ["Рога без копыт"]          
    end
  end
end

