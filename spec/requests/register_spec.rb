#encoding: utf-8;
require 'spec_helper'

describe 'Регистрация пользователя' do

before(:each) do
  ActionMailer::Base.deliveries.clear
  Factory(:role_firm_user)
  Factory(:role_user)
  Factory(:firm)
  @admin = Factory(:admin)
end

  it 'регистрация с главной страницы' do
    visit "/register"
    page.should have_field "Рекламное агентство"
    page.should have_field "Представитель компании (Юридическое лицо)"
  end


  
  it 'рекалмное агентство' do
    visit "/register"
    choose "Рекламное агентство"
    click_button "Далее"
    page.should have_selector "h1", :text => "Рекламное агентство"    
    fill_in "Имя, фамилия", :with => "demo"
    fill_in "Компания", :with => "Копыта"
    fill_in "Город", :with => "Москва"
    fill_in "E-mail", :with => "kopyta@giftb2b.ru"    
    fill_in "Телефон", :with => "903 129-432-4"    
    click_button "Зарегистрироваться"
    page.should have_selector "h2", :text => "Благодарим за регистрацию"
    page.should have_content "В течение двух минут будет отправлен пароль на указанный Вами e-mail."
    page.should have_content "бесплатно в течение 3 дней"
    Firm.last.name.should eq "Копыта"
    Firm.last.city.should eq "Москва"    
    Firm.last.users.should have(1).records
    User.last.should be_is_firm_user
    ActionMailer::Base.deliveries.should have(2).items
    ActionMailer::Base.deliveries.map(&:to).should include([@admin.email])      
    ActionMailer::Base.deliveries.map(&:to).should include(["kopyta@giftb2b.ru"])      
    ActionMailer::Base.deliveries.last.body.should match("Рекламное агентство")
    ActionMailer::Base.deliveries.first.body.should match(User.last.username)
  end
  
   it 'Представитель компании' do
    visit "/register"
    choose "i_am_2"
    click_button "Далее"
    page.should have_selector "h1", :text => "Представитель компании"    
    fill_in "Имя, фамилия", :with => "demo"
    fill_in "Компания", :with => "Копыта"
    fill_in "Город", :with => "Москва"
    fill_in "E-mail", :with => "kopyta@giftb2b.ru"    
    fill_in "Телефон", :with => "903 129-432-4"    
    click_button "Зарегистрироваться"
    page.should have_selector "h2", :text => "Благодарим за регистрацию"
    page.should have_content "В течение двух минут будет отправлен пароль на указанный Вами e-mail."
    page.should have_no_content "бесплатно в течение 3 дней"
    Firm.all.should have(1).record
    User.last.should be_is_simple_user
    ActionMailer::Base.deliveries.should have(2).items
    ActionMailer::Base.deliveries.map(&:to).should include([@admin.email])      
    ActionMailer::Base.deliveries.map(&:to).should include(["kopyta@giftb2b.ru"])      
    ActionMailer::Base.deliveries.last.body.should match("Представитель компании")
    ActionMailer::Base.deliveries.first.body.should match(User.last.username)
  end

  
  context "регистрация РА или ЮР лица" do
    let(:product) {Factory(:product)}    
      it 'регистрация при оформлении заказа из карточки товара' do
        visit product_path(product)
        click_link "Оформить заказ"
        page.should have_content "Кто Вы?"
      end    
    end
  
end
