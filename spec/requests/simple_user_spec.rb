#encoding: utf-8;
require 'spec_helper'

describe "Работа обычного пользователя" do 
  before(:each) do
    login_as :user
    @product = Factory(:product)
    @firm = Factory(:firm)
    ActionMailer::Base.deliveries.clear
  end
  
   
  it 'я могу добавить товар в корзину', :js => true do
    visit "/"
    within "ul.treeview span" do
      click_link @product.categories.first.name
    end
    within "#product_#{@product.id}" do
      click_link "Pix"
    end
    within "#cart" do
      page.should have_content "Корзина: 1 товар"
    end
  end
  
  it 'я оформляю заказ', :js => true do
      visit product_path(@product)
      click_link "Добавить в корзину"
      visit cart_index_path
      click_button "Оформить заказ"
      fill_in "Комментарий", :with => "Комментарий к заказу"
      within "#firms" do
        page.should have_content @firm.subway    
        page.should have_content @firm.city
        page.should have_content @firm.addr_f        
        click_button "Отправить заказ"
      end            
      page.should have_content "Заказ оформлен"  
      save_and_open_page
      @order = LkOrder.where(:firm_id => @firm.id).first
      @order.should be_is_remote
      ActionMailer::Base.deliveries.should have(2).items
      ActionMailer::Base.deliveries.map(&:to).should include([@order.firm.email])      
      ActionMailer::Base.deliveries.map(&:to).should include([@order.user.email])      
      within "#cart" do
        page.should have_content "пусто"
      end
  end
  
#  
  it 'в личном кабинете я вижу свои заказы' do
    @lk_order = Factory(:lk_order, :user => @user)
    visit root_path
    click_link "Личный кабинет"
    visit orders_path
    page.should have_content "Список заказов"
  end

  it 'я не могу посмотреть заказы, созданные другим пользователем' do
    order2= Factory(:lk_order, :user_id => @user.id + 1)
    visit order_path(order2)
    #page.should have_content "Заказ не найден!"
    page.status_code.should eq 404
  end


  context 'выбор где заказать' do
    
  end
#  it 'После отправки заказа я должен получить письмо' do
#    pending
#  end
end
