#encoding: utf-8;
require 'spec_helper'

describe 'Регистрация пользователя' do

before(:each) do
  ActionMailer::Base.deliveries.clear
  Factory(:role_firm_user)
  Factory(:role_user)
  Factory(:firm, :id => 1, :permalink => "test-auth-firm")
  @admin = Factory(:admin)
end

  it 'регистрация с главной страницы' do
    visit "/auth/register"
    page.should have_field "Рекламное агентство"
    page.should have_field "Представитель компании (Юридическое лицо)"
  end


  
  it 'рекалмное агентство' do
    ActionMailer::Base.default_url_options[:host] = "giftpoisk.ru"
    visit "/auth/register"
    choose "Рекламное агентство"
    click_button "Далее"
    page.should have_selector "h1", :text => "Рекламное агентство"   
    fill_in "Имя, фамилия", :with => "demo"
    fill_in "Компания", :with => "Копыта"
    fill_in "Город", :with => "Москва"
    fill_in "E-mail", :with => "kopyta@giftb2b.ru"    
    fill_in "Телефон", :with => "903 129-432-4"    
    fill_in "Сайт", :with => "http://dishouse.ru"    
    click_button "Зарегистрироваться"
    page.should have_selector "h2", :text => "Благодарим за регистрацию"
    page.should have_content "giftpoisk.ru"
    Firm.where(:name =>  "Копыта").should have(1).record
    Firm.last.city.should eq "Москва"    
    Firm.last.url.should eq "http://dishouse.ru"
    Firm.last.users.should have(1).records
    User.last.should be_is_firm_user
    ActionMailer::Base.deliveries.should have(2).items
    ActionMailer::Base.deliveries.map(&:to).should include([@admin.email])      
    ActionMailer::Base.deliveries.map(&:to).should include(["kopyta@giftb2b.ru"])      
    ActionMailer::Base.deliveries.last.body.should match("Рекламное агентство")
    ActionMailer::Base.deliveries.first.body.should match(User.last.username)
  end
  
  it 'рекламное агентство с гифта перенаправлено на гифтпоиск' do
    ActionMailer::Base.default_url_options[:host] = "giftb2b.ru" 
    visit "/auth/register"
    choose "i_am_1"
    click_button "Далее"
    page.current_url.should eq("http://giftpoisk.ru/auth/register?step=2")
  end
  
   it 'конечный клиент с гифтпоиска перенаправлен на гифт' do
    ActionMailer::Base.default_url_options[:host] = "giftpoisk.ru" 
    visit "/auth/register"
    choose "i_am_2"
    click_button "Далее"
    page.current_url.should eq("http://giftb2b.ru/auth/register?step=2")
  end
  
   it 'Представитель компании' do
    ActionMailer::Base.default_url_options[:host] = "giftb2b.ru" 
    visit "/auth/register"
    choose "i_am_2"
    click_button "Далее"
    page.should have_selector "h1", :text => "Представитель компании"    
    fill_in "Имя, фамилия", :with => "demo"
    fill_in "Компания", :with => "Копыта"
    fill_in "Город", :with => "Москва"
    fill_in "E-mail", :with => "kopyta@giftb2b.ru"    
    fill_in "Телефон", :with => "903 129-432-4"    
    fill_in "Сайт", :with => "http://dishouse.ru"    
    click_button "Зарегистрироваться"
    page.should have_selector "h2", :text => "Благодарим за регистрацию"
    page.should have_content "giftb2b.ru"
    Firm.all.should have(1).record
    User.last.should be_is_simple_user
    ActionMailer::Base.deliveries.should have(2).items
    ActionMailer::Base.deliveries.map(&:to).should include([@admin.email])      
    ActionMailer::Base.deliveries.map(&:to).should include(["kopyta@giftb2b.ru"])      
    ActionMailer::Base.deliveries.last.body.should match("Представитель компании")
    ActionMailer::Base.deliveries.first.body.should match(User.last.username)
  end

  
#  context "регистрация РА или ЮР лица" do
#    let(:product) {Factory(:product)}    
#      it 'регистрация при оформлении заказа из карточки товара' do
#        visit product_path(product)
#        click_link "Оформить заказ"
#        page.should have_content "Кто Вы?"
#      end    
#    end
  
  context 'восстановление пароля' do
    
    it 'я могу восстановить пароль' do
      visit "/auth/recovery"
      page.should have_selector "h1", :text => "Восстановление пароля"
      page.should have_field "Введите Ваш E-mail"
    end

    it 'валидность email' do
      visit "/auth/recovery"
      fill_in "email", :with => 'aaa'
      click_button "Восстановить пароль"
      page.should have_selector "#flash_alert", :text => "Неправильный адрес Email"
      fill_in "email", :with => 'aaaa@example.com'
      click_button "Восстановить пароль"
      page.should have_selector "#flash_alert", :text => "Пользователь с таким именем не найден!"
    end
    
    it 'неактивированный пользователь не может запросить восстановление пароля' do
       visit "/auth/recovery"
      user = Factory(:user, :active => false)
      fill_in "email", :with => user.email
      click_button "Восстановить пароль"
      page.should have_selector "#flash_alert", :text => "Пользователь с таким именем не найден!"      
    end

    
    it 'восстановление пароля' do
      user = Factory(:user)
      visit "/auth/recovery"
      fill_in "email", :with => user.email
      click_button "Восстановить пароль"
      page.should have_selector "h1", :text => "Ваш пароль изменен!"
      UserSession.find.should be_nil
#      save_and_open_page
#      page.should have_selector "form#login_form"
      ActionMailer::Base.deliveries.should have(1).item
      ActionMailer::Base.deliveries.map(&:to).should include([user.email])      
      ActionMailer::Base.deliveries.first.body.should match(user.username)      
      ActionMailer::Base.deliveries.first.body.should have_selector "#new_password"
    end
    
  end
  
end
