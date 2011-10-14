#encoding: utf-8;

require 'spec_helper'

describe 'Управление заказами в личном кабинете' do  
  before(:each) do    
    ActionMailer::Base.default_url_options[:host] = "giftpoisk.ru"
    login_as :firm_manager
     @firm = Factory(:firm)
     @user.update_attributes(:firm => @firm, :fio => "Петр Иванов")    
     @lk_firm = Factory(:lk_firm, :firm_id => @firm.id)         
     @lk_order = Factory(:lk_order, :firm => @user.firm, :lk_firm => @lk_firm)
   end
  
  
      context 'отправка писем' do                 
         it 'После изменения статуса заказа заказчику отправляется уведомление' do
          visit edit_order_path(@lk_order)
          save_and_open_page
          select "макет на утверждении", :from => "lk_order_status_id"
          click_button "Сохранить"
          ActionMailer::Base.deliveries.should have(1).item
          ActionMailer::Base.deliveries.first.to.should include(@lk_order.contact_email)
         end
     end

end
