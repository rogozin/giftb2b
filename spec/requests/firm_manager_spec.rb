#encoding: utf-8;
require 'spec_helper'

describe 'Роль менеджер фирмы' do
  before(:each) do
     login_as :firm_manager    
     @firm = Factory(:firm)
     @user.update_attributes(:firm => @firm, :fio => "Петр Иванов")    
     @lk_firm = Factory(:lk_firm, :firm_id => @firm.id)         
  end
  
  context 'учет образцов' do   
   it 'я могу поставить признак возврата денег на странице образца' do
     @user.has_role! "Учет образцов"
     @sample = Factory(:sample, :closed => true)
     visit edit_lk_sample_path(@sample)
     page.should have_checked_field "sample_closed"
   end
  end
   
   
   context 'личный кабинет' do
     before(:each) do
       @commercial_offer = Factory(:commercial_offer, :firm => @user.firm)
     end
     it 'могу преобразовать коммерческое предложение в заказ', :js => true do
       visit lk_commercial_offer_path(@commercial_offer)
       click_link "Преобразовать в заказ"
       page.should have_select "lk_firm", :selected => @commercial_offer.lk_firm.name
       page.click_button "Преобразовать"
       page.should have_selector("#flash_notice", :text => "Заказ успешно сгенерирован из коммерческого предложения")
       order = LkOrder.last
       page.current_path.should == edit_lk_order_path(order)
     end
   end
   
    
   
end
