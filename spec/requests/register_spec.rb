#encoding: utf-8;
require 'spec_helper'

describe 'Регистрация пользователя' do
before(:each) do
  Factory(:firm)
end
  it 'регистрация с главной страницы' do
    visit "/register"
    fill_in "Имя пользователя", :with => "demo"
    fill_in "Email", :with => "no-name@giftb2b.ru"    
    fill_in "Пароль", :with => "demo"    
    fill_in "Подтверждение пароля", :with => "demo"
#    save_and_open_page
    click_button "Сохранить"
    page.should have_content "На Ваш почтовый адрес отправлено письмо с кодом для активации учетной записи"
    ActionMailer::Base.deliveries.should have(1).items
    ActionMailer::Base.deliveries.map(&:to).should include(["no-name@giftb2b.ru"])      
  end

  it 'активация учетной записи' do
      pending
  end
  
  context "регистрация РА или ЮР лица" do
    let(:product) {Factory(:product)}
    
      it 'регистрация при оформлении заказа из карточки товара' do
        visit product_path(product)
        click_button "Оформить заказ"
        page.should have_content "Кто Вы?"
        page.should have_checked_field "Рекламное агенство"
        page.should have_checked_field "Представитель компании (Юридическое лицо)"
      end
    
    end
  
end
