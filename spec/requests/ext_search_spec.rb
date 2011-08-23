#encoding: utf-8;
require 'spec_helper.rb'


describe 'расширенный поиск' do
  before(:each) do
     login_as :firm_manager    
  end
  
  it 'проверка поиска по артикулу' do
    @product = Factory(:product, :article => "4706")
    visit search_path
    fill_in "article", :with => @product.article
   click_button "go_search"
    page.should have_selector "#product_#{@product.id}"
  end   
     
        
  it 'товар в евро, цена ищится нормально' do
    @product = Factory(:product, :currency_type => "EUR", :price => 10)
    @product_1 = Factory(:product, :currency_type => "RUB", :price => 10)
    visit search_path
    fill_in "price_from", :with => 0
    fill_in "price_to", :with => 20
    click_button "go_search"
    page.should have_no_selector "#product_#{@product.id}"
    page.should have_selector "#product_#{@product_1.id}"
    save_and_open_page
   end
      
end
