#encoding: utf-8;
require 'spec_helper.rb'


describe 'расширенный поиск' do
  before(:each) do
      Settings.stub(:giftb2b?).and_return(false)
      Settings.stub(:giftpoisk?).and_return(true)    
    @cp = Factory(:color_property, :name => "Цвет")
    @color1 = @cp.property_values.create(:value => "Черный", :note => "#000000")
    @infliction = Factory(:text_property, :name => "Нанесение")
    @material = Factory(:text_property, :name => "Материал")
    @val1 = @material.property_values.create(:value => "Пластик")
    @val2 = @material.property_values.create(:value => "Дерево")          
    @product = Factory(:product, :article => "4706")
#    Factory(:category, :kind => 2)
#    Factory(:category, :kind => 3)
#    Factory(:category, :kind => 0)
    
  end
  
  context 'Полный доступ к поиску' do
    before(:each) do
      login_as :user
      @user.role_objects << Factory(:r_search)
    end
  
    it 'проверка поиска по артикулу' do        
      visit search_path
      fill_in "article", :with => @product.article
      click_button "Найти"
      page.should have_selector "#product_#{@product.id}"
    end   
  end
  
   context 'Ролль Интернет-магазин' do
     before(:each) do
      login_as :user
      @user.role_objects << Factory(:r_orders)       
     end
  
     it 'в сокращенном поиске доступно поле "Артикул"' do
       visit search_path
       within "#ext_search_form" do
         page.should have_field "article"
         page.should have_no_content "Поставщик"         
         page.should have_no_content "Материал"                  
       end
     end  
   end
     
      
end
