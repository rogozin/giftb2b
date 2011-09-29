#encoding:utf-8;
require 'spec_helper.rb'

describe 'Действия для незарегистрированного пользователя' do
  before(:each) do
    @product = Factory(:product)
    @firm = Factory(:firm)
  end
  
  
  it 'нет корзины без пароля' do
    visit "/"
    page.should have_no_content "Корзина"
    page.should have_no_selector "#cart"
    visit product_path(@product)
    within "#product_#{@product.id}" do
      page.should have_link "Регистрация"
      page.should have_link "Спец. условия для рекламных агентств"
    end      
        
  end
  
end
