#encoding:utf-8;
require 'spec_helper'


describe 'Работа с банерами' do
  before(:each) do
    login_as(:admin)
    @firm = Factory(:firm)        
    @banner = Factory(:banner, :firm => @firm)
  end
  
  it 'я могу добавить баннер' do
    visit '/admin/banners/'
    click_link "Создать новый баннер"
    page.should have_content "Создание нового баннера"
    page.should have_no_checked_field "Активен?"
    page.select @firm.short_name, :from => "Фирма"
    fill_in "Текст", :with => "Заказать сувениры"
    check "Активен?"
    click_button "Сохранить"
    page.should have_content "Баннер успешно создан"  
    page.current_path.should == edit_admin_banner_path(Banner.last)
  end
    
  
  it 'редактирование баннера' do
    firm_1 = Factory(:firm)
    visit admin_banners_path
    within "#banners_list table" do 
      click_link "Edit"
    end
    page.should have_content "Редактирование баннера"
    page.should have_select("Фирма", :selected => @banner.firm.short_name)
    fill_in "Текст", :with => "ОЛОЛО"
    click_button "Сохранить"
    page.should have_content "Баннер изменен"
  end
  
  it 'Удаление банера' do
    visit admin_banners_path
    within "#banners_list table" do 
      click_link "Bin"
    end
    page.should have_content "Баннер удален"
  end
  
  it 'Просмотр банера на главной' do
    visit '/'
    page.should have_selector "#test_banner"
  end
  
end
