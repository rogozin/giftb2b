#encoding: utf-8;
require 'spec_helper'

describe 'Главная страница' do
  before(:each) do
    visit '/'
  end
  context 'Ликвидация остатков' do
    before(:each) do
      @product = Factory(:product, :is_sale => true) 
    end

    it 'Просмотр товаров, у которых стоит признак is_sale' do
      click_link "Ликвидация остатков"
      within "#catalog_items" do
        page.should have_content @product.short_name
      end
    end  
  end
end
