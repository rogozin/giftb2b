#encoding: utf-8;
require 'spec_helper'

describe 'Тестирование складов' do
  before(:each) do
    login_as(:admin)
  end
  
  let(:supplier) { Factory(:supplier) }
  
  it 'я перехожу на страницу редактирования поставщика и вижу основной склад' do
    visit edit_admin_supplier_path(supplier.id)
    page.should have_content "Склады"
    within "#stores" do
      page.should have_content "основной"
    end    
  end
  
  it 'я могу добавить новый склад' do
    visit edit_admin_supplier_path(supplier.id)
    click_link "Добавить новый склад"
    page.should have_selector "h1", :text => "Создание склада"    
    fill_in "Название", :with => "дополнительный"
    fill_in "Местонахождение", :with => "Европа"
    fill_in "Срок поставки", :with => "2 недели"
    click_button "Сохранить"
    page.should have_content "Склад создан"
    page.current_path.should eq edit_admin_supplier_path(supplier.id)
    within "#stores" do
      page.should have_content "дополнительный"
      page.should have_content "Европа"
    end
  end
  
  it 'я могу отредактировать существующий склад' do
    visit edit_admin_supplier_path(supplier.id)
    within "#stores table" do
      click_link "Edit"
    end
    page.should have_selector "h1", :text => "Редактирование склада"
    fill_in "Название", :with => "дополнительный"
    fill_in "Местонахождение", :with => "Европа"
    fill_in "Срок поставки", :with => "2 недели"
    click_button "Сохранить"
    page.should have_content "Склад изменен"
    page.current_path.should eq edit_admin_supplier_path(supplier.id)
    within "#stores" do
      page.should have_content "дополнительный"
      page.should have_content "Европа"
    end
  end  

  it 'последний склад нельзя удалить' do
    pending
  end

  it 'я могу удалить склад', :js => true do
    store = supplier.stores.create(:name => "дополнительный")
    visit edit_admin_supplier_path(supplier.id)
    page.should have_selector "#store_table tr", :count => 3
    page.evaluate_script('window.confirm = function() { return true; }')
    within "#store_#{store.id}" do
      click_link "Bin"
    end    
    page.should have_selector "#store_table tr", :count => 2
  end
  
  
end
