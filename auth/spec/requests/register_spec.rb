#encoding: utf-8;
require 'spec_helper'

describe 'Регистрация пользователя' do

before(:each) do
  ActionMailer::Base.deliveries.clear
  Factory(:service, :code => "lk_supplier", :roles => [Factory(:lk_supplier)])
  Factory(:service, :code => "base_ext_search", :roles => [Factory(:r_search)])
  Factory(:service, :code => "co_logo", :roles => [Factory(:r_co), Factory(:r_logo)])
  Factory(:service, :code => "my_goods", :roles => [Factory(:r_products)])
  Factory(:service, :code => "s_cli", :roles => [Factory(:r_samples), Factory(:r_clients)])
  Factory(:role_user)
  Factory(:firm, :id => 1, :permalink => "test-auth-firm")
  @admin = Factory(:admin)
end

  it 'регистрация с главной страницы' do
    visit "/auth/register"
    page.should have_field "Рекламное агентство"
    page.should have_field "Представитель компании (Юридическое лицо)"
    page.should have_field "Поставщик сувенирной продукции"
  end


  
  it 'рекалмное агентство' do
    ActionMailer::Base.default_url_options[:host] = "giftpoisk.ru"
    Settings.stub(:giftpoisk?).and_return(true)    
    Settings.stub(:giftb2b?).and_return(false)        
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
    Firm.first.attach_images.first.attachable_type.should eq "Firm"
    Firm.first.logo.path.split("/").last.should eq "logo-default.jpg"
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
    Settings.stub(:giftpoisk?).and_return(true)
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

  
    it 'Поставщик' do
    ActionMailer::Base.default_url_options[:host] = "giftpoisk.ru"
    Settings.stub(:giftpoisk?).and_return(true)    
    Settings.stub(:giftb2b?).and_return(false)        
    visit "/auth/register"
    choose "Поставщик сувенирной продукции"
    click_button "Далее"
    page.should have_selector "h1", :text => "Поставщик сувенирной продукции"      
    fill_in "Имя, фамилия", :with => "demo"
    fill_in "Компания", :with => "Копыта"
    fill_in "Город", :with => "Москва"
    fill_in "E-mail", :with => "kopyta@giftb2b.ru"    
    fill_in "Телефон", :with => "903 129-432-4"    
    fill_in "Сайт", :with => "http://dishouse.ru"    
    click_button "Зарегистрироваться"
    page.should have_selector "h2", :text => "Благодарим за регистрацию"
    page.should have_content "giftpoisk.ru"
    page.should have_content "поставщик"
    Firm.where(:name =>  "Копыта").should have(1).record
    Firm.last.city.should eq "Москва"    
    Firm.last.url.should eq "http://dishouse.ru"
    Firm.last.users.should have(1).records
    User.last.should be_is_lk_supplier
    Firm.first.attach_images.first.attachable_type.should eq "Firm"
    Firm.first.logo.path.split("/").last.should eq "logo-default.jpg"
    ActionMailer::Base.deliveries.should have(2).items
    ActionMailer::Base.deliveries.map(&:to).should include([@admin.email])      
    ActionMailer::Base.deliveries.map(&:to).should include(["kopyta@giftb2b.ru"])      
    ActionMailer::Base.deliveries.last.body.should match("Поставщик")
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
      page.should have_selector "h2", :text => "Забыли пароль?"
      page.should have_field "Ваш email"
    end

    it 'левый email' do
      visit "/auth/recovery"
      fill_in "email", :with => 'aaa'
      click_button "Отправить инструкцию по сбросу пароля"
      within "#error_explanation" do      
        page.should have_content "не найдена"      
      end
    end
    
    it 'неактивированный пользователь не может запросить восстановление пароля' do
       visit "/auth/recovery"
      user = Factory(:user, :active => false)
      fill_in "email", :with => user.email
      click_button "Отправить инструкцию по сбросу пароля"
      within "#error_explanation" do      
        page.should have_content "заблокирована"      
      end
    end

    
    it 'восстановление пароля' do
      user = Factory(:user)
      visit "/auth/recovery"
      fill_in "email", :with => user.email
      click_button "Отправить инструкцию по сбросу пароля"
      ActionMailer::Base.deliveries.should have(1).item
      ActionMailer::Base.deliveries.map(&:to).should include([user.email])      
      ActionMailer::Base.deliveries.first.body.should match(user.email)    
      user.reload        
      visit "/auth/users/password/edit/?reset_password_token=#{user.reset_password_token}"
      page.should have_selector "h2", :text => "Придумайте новый пароль:"
      fill_in "user_password", :with => "test"
      fill_in "user_password_confirmation", :with => "test"
      click_button "Изменить пароль"
      page.should have_content "Вы вошли как #{user.username}"
    end
    
  end
  
end
