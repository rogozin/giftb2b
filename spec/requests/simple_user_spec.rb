require 'spec_helper'

describe "Работа обычного пользователя" do 
  before(:each) do
    login_as :user
    @product = Factory(:product)
  end
    
  it 'я могу добавить товар в корзину', :js => true do
    visit "/"
    within "ul.treeview" do
      click_link "Подарки"
    end
    within "#product_#{@product.id}" do
      click_link "+"
    end
    within "#cart" do
      page.should have_content "Корзина: 1 товар"
    end
  end
  
  it 'я оформляю заказ', :js => true do
      @firm = Factory(:firm)
      visit product_path(@product)
      click_link "Добавить в корзину"
      visit cart_index_path
      click_link "Оформить заказ"
      select @firm.short_name, :from => "lk_order_firm_id"
      fill_in "Комментарий", :with => "Примечание к заказу"
      click_button "Оформить"
      page.should have_content "Заказ оформлен!"  
      within "#cart" do
        page.should have_content "пусто"
      end
      save_and_open_page
  end
  
#  
  it 'в личном кабинете я вижу свои заказы' do
    @lk_order = Factory(:lk_order)
    visit lk_orders_path 
  end


  it 'После отправки заказа я должен получить письмо' do
    
  end
end
