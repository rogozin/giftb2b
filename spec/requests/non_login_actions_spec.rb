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
    visit category_path(@product.categories.first)
    within "#product_#{@product.id}" do
      page.should have_button "Оформить заказ"
    end  
    visit product_path(@product)
    within "#product_#{@product.id}" do
      page.should have_button "Оформить заказ"
      page.should have_link "Спец. условия для РА"
    end      
        
  end
  
  it 'регистрация вместо добавить в корзину' do
    
  end
  
  context 'Оформление заказа' do
    before(:each) do
      visit product_path(@product)
      click_link "Добавить в корзину"
      visit cart_index_path
      click_button "Оформить заказ"      
    end
    
    it 'я не могу оформить заказ, если не укажу email или телефон', :js => true do
      fill_in "lk_order_user_name", :with => "Илья"  
      within "#firms" do
        click_button "Отправить заказ"
      end
      page.should have_selector "#flash_alert", :text => "Укажите контактную информацию: email или телефон"
      page.should have_field "lk_order_user_name", :with => "Илья"      
    end
    
    it 'я не могу оформить заказ, если введу невалидный email', :js => true do
      #Современные браузеры не дают ввести невалидный email в email_field
#=============================================================================
#      fill_in "Ваше имя", :with => "Илья"
#      fill_in "Email", :with => "Илья"
#      within "#firms" do
#        click_button "Отправить заказ"
#      end
#      page.should have_selector "#flash_alert", :text => "Введите корректный email"
#      #После редиректа поля должны быть заполнены
#      page.should have_field "Email", :with => "Илья"
#      page.should have_field "Ваше имя", :with => "Илья"      
    end
    
    it 'я оформляю заказ', :js => true do
      Factory(:role_user)
      fill_in "lk_order_user_comment", :with => "Комментарий к заказу"
      fill_in "lk_order_user_name", :with => "Илья"            
      fill_in "lk_order_user_email", :with => "demo-user@mail.com"            
      within "#firms" do
        page.should have_content @firm.subway    
        page.should have_content @firm.city
        page.should have_content @firm.addr_f        
        click_button "Отправить заказ"
      end            
      @order = LkOrder.where(:firm_id => @firm.id).first
      @order.should be_is_remote
      page.should have_content "Заказ оформлен"  
      page.should have_content @firm.short_name
      click_link "личном кабинете"
      page.should have_content "Список заказов"
      page.should have_content @order.firm.short_name
      ActionMailer::Base.deliveries.should have(3).items
      ActionMailer::Base.deliveries.map(&:to).should include([@order.firm.email])      
      ActionMailer::Base.deliveries.map(&:to).should include([@order.user.email])      
      within "#cart" do
        page.should have_content "пусто"
      end
    end
  end
  
end
