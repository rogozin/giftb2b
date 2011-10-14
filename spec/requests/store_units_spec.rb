#encoding:utf-8;
require 'spec_helper.rb'

describe 'Информация о наличии на складе' do
  before(:each) do
    @product = Factory(:product)
    @store1 = Factory(:store, :supplier => @product.supplier, :location => "Москва", :delivery_time => "")
    @store2 = Factory(:store, :supplier => @product.supplier)
    @store3 = Factory(:store, :supplier => @product.supplier)
    @product.store_units.create(:store => @store1, :count => 5)
    @product.store_units.create(:store => @store2, :count => 10)
    @product.store_units.create(:store => @store3, :count => 10, :option => 0)
    @firm = Factory(:firm)
  end
  
  context "незарегистрированный пользователь" do          
    it 'не видит кол-во на складе в списке товаров' do
      visit category_path(@product.categories.first)
      page.should have_no_content "Наличие на складе"
    end
    
    it 'видит общее кол-во в карточке товара' do
      visit product_path(@product)
      page.should have_content "Наличие на складе: 15"
    end        
  end
  
  context 'обычный пользователь' do
    before(:each) do
      login_as(:simple_user)
    end
    it 'не видит кол-во на складе в списке товаров' do
      visit category_path(@product.categories.first)
      page.should have_no_content "Наличие на складе"
    end
    
    it 'видит общее кол-во в карточке товара' do
      visit product_path(@product)
      page.should have_content "Наличие на складе: 15"
    end    
  end
  
  context 'менеджер фирмы' do
    before(:each) do
      login_as(:firm_manager)
    end
    it 'видит суммарное кол-во на складе в списке товаров' do
      visit category_path(@product.categories.first)
      page.should have_content "Кол-во на складе: 15 шт."
    end
    
    it 'видит общее кол-во в карточке товара' do
      visit product_path(@product)
      within "#product_#{@product.id}" do
        page.should have_selector(".b-product-store-units", :count => 3)
        page.should have_content @store1.location
        page.should have_content @store2.location
        page.should have_content @store2.delivery_time
        save_and_open_page
        page.should have_content "по запросу"        
        within first(".b-product-store-units") do
          page.should have_no_content "Срок поставки"
        end
      end
    end    
  end  
  
end
