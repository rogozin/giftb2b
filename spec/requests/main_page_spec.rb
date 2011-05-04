#encoding: utf-8;
require 'spec_helper'

describe 'Главная страница' do
  before(:each) do
    visit '/'
  end
  context 'Выгодные предложения' do
    context "Просмотр выгодных предложений" do
      before(:each) do
        @product = Factory(:product, :is_sale => true, :best_price => true) 
      end
    
      it 'Ликвидация остатков' do
        click_link "Ликвидация остатков"
        within "#catalog_items" do
          page.should have_content @product.short_name
        end
        page.should have_selector "#product_#{@product.id}"
      end  

      it 'Отличная цена' do
        click_link "Отличная цена"
        page.should have_selector "#product_#{@product.id}"
      end
      
      it 'с выключенными опциями я не вижу ничего' do
        @product.toggle! :is_sale
        @product.toggle! :best_price
        visit on_sale_categories_path
        page.should have_no_selector "#product_#{@product.id}"
        visit best_price_categories_path
        page.should have_no_selector "#product_#{@product.id}"
      end


    end #context
  end #context
end #describe
