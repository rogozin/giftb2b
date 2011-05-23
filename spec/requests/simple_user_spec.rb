require 'spec_helper'

describe "Работа обычного пользователя" do 
  before(:each) do
    login_as :user
    @product = Factory(:product)
    @firm = Factory(:firm)
  end
  
  it 'Видимость пунктов меню личного кабинета' do
    visit lk_index_path
    within "#user_menu" do
      page.should have_content("Мои заказы")
      page.should have_content("Мой профиль")
      page.should have_content("Подписки")
      page.should have_no_content("Список заказов")
      page.should have_no_content("Коммерческие предложения")
      page.should have_no_content("Мои фирмы")
      page.should have_no_content("Мои товары")
      page.should have_no_content("Пользователи")
    end
  end  
    
  it 'я могу добавить товар в корзину', :js => true do
    visit "/"
    within "ul.treeview" do
      click_link @product.categories.first.name
    end
    within "#product_#{@product.id}" do
      click_link "+"
    end
    within "#cart" do
      page.should have_content "Корзина: 1 товар"
    end
  end
  
  it 'я оформляю заказ', :js => true do
      visit product_path(@product)
      click_link "Добавить в корзину"
      visit cart_index_path
      click_link "Оформить заказ"
      select @firm.short_name, :from => "lk_order_firm_id"
      fill_in "Комментарий", :with => "Примечание к заказу"
      save_and_open_page
      click_button "Оформить"
      page.should have_content "Заказ оформлен!"  
      within "#cart" do
        page.should have_content "пусто"
      end
  end
  
#  
  it 'в личном кабинете я вижу свои заказы' do
    @lk_order = Factory(:lk_order, :user => @user)
    visit lk_index_path
    click_link "Мои заказы" 
    page.should have_content "Список заказов"
  end

  it 'я не могу посмотреть заказы, созданные другим пользователем' do
    order2= Factory(:lk_order, :user_id => @user.id + 1)
    visit lk_user_order_path(order2)
    page.should have_content "Заказ не найден!"
  end


  context 'выбор где заказать' do
    
  end
#  it 'После отправки заказа я должен получить письмо' do
#    pending
#  end
end
