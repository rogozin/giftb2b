require 'spec_helper'

  def login_as user_role
    @user = Factory(user_role)
    visit login_path
    within "#login" do
      fill_in "user_session[username]", :with => @user.username
      fill_in "user_session[password]", :with => @user.password
      click_button "Войти"
    end
  end

describe "ограничения  редактора каталога" do
  before(:each) do
    login_as :catalog_editor
    CurrencyValue.create({:dt => Date.today, :usd => 30, :eur => 40})
    @product = Factory :product
    @product2 = Factory :product, :categories =>@product.categories
    @user.update_attribute(:supplier_id,  @product.supplier_id)    
  end
  
  context 'Если пользователю не назначен поставщик' do
    before(:each) do
      @user.update_attribute(:supplier_id, nil)
    end
    
    it 'не должен видеть товары на основном сайте ' do
      visit category_path(@product.categories.first)
      page.should have_no_css('div.article')      
    end
    
    it 'не должен видеть товары в админке' do
      visit admin_products_path
      page.should have_selector("table#products_list tr", :count => 1)
    end
    
  end
  
  context 'На основном сайте' do
    before(:each) do
       visit category_path(@product.categories.first)
    end
  
    it 'Редактор должен видеть только товары назначенного ему поставщика' do
     page.should have_css('div.article', :count => 1)
    end
  
    it 'Редактор не должен иметь возможность устанавливать фильтр по поставщику' do
      page.should have_no_content("Фильтр по поставщику")      
    end
  end
  
  context 'В админке редактор каталога' do
    it 'на странице товаров должен видеть только товары своего поставщика' do
      visit admin_products_path
      page.should have_no_select("supplier")
      page.should have_selector("table#products_list tr", :count => 2)
    end
    
    it 'на странице категории  видит только товары своего поставщика', :js => true do
      visit edit_admin_category_path(@product.categories.first)
      click_link "Показать список товаров"
      save_and_open_page      
      page.should have_selector("ul#products li", :count => 1)
    end
    
  end
  
end
