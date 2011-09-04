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
   
   context "Коммерческое предложение" do    
     before(:each) do
       @commercial_offer = Factory(:commercial_offer, :firm => @user.firm, :lk_firm => @lk_firm)
     end
     it 'могу преобразовать коммерческое предложение в заказ', :js => true do
       new_firm = Factory(:lk_firm, :name => "Рога и копыта", :firm_id => @firm.id)         
       visit lk_commercial_offer_path(@commercial_offer)
       click_link "Преобразовать в заказ" 
       page.should have_select "lk_firm", :selected => @commercial_offer.lk_firm.name
       page.select new_firm.name, :from => "lk_firm"
       page.click_button "Преобразовать"
       page.should have_selector("#flash_notice", :text => "Заказ успешно сгенерирован из коммерческого предложения")
       order = LkOrder.last
       order.lk_order_items.first.price.should == @commercial_offer.commercial_offer_items.first.lk_product.price
       order.lk_firm_id.should == new_firm.id
       page.current_path.should == edit_lk_order_path(order)
     end
     
     it 'Удаление товара из коммерческого предложения' do
       @lk_order = Factory(:lk_order, :firm =>@user.firm)
       @lk_product  = @commercial_offer.commercial_offer_items.first.lk_product
       @lk_order.lk_order_items.create(:product => @lk_product, :quantity => 1, :price => 10)
       visit lk_commercial_offer_path(@commercial_offer)       
       within "#commercial_offer_items" do
         click_link "Bin"
       end
       page.should have_content("Товар исключен из коммерческого предложения")
       @commercial_offer.commercial_offer_items.size.should == 0
     end
   end
   
   context 'Заказ' do
     before(:each) do
       @lk_order = Factory(:lk_order, :firm => @user.firm, :lk_firm => @lk_firm)
     end
     
     context 'отправка писем' do
            
       it 'После создания заказа через апи письмо уходит заказчику и фирме ' do
          #see this spec in api/api_spec.rb
       end
       
       it 'после создания заказа через личный кабинет письмо уходит заказчику' do
          #see this spec in api/api_spec.rb
       end
     
       it 'После изменения статуса заказа заказчику отправляется уведомление' do
        visit edit_lk_order_path(@lk_order)
        select "макет на утверждении", :from => "lk_order_status_id"
        click_button "Сохранить"
        ActionMailer::Base.deliveries.should have(1).item
        ActionMailer::Base.deliveries.first.to.should include(@lk_order.contact_email)
       end

     end
     
   end

    context 'Мои товары' do 
      before(:each) do
        @lk_product = Factory(:lk_product, :firm => @firm)        
      end

      it 'В моем товаре я вижу опцию Показывать на сайте только когда есть удаленный доступ к каталогу' do
        Rails.cache.clear
        @lk_product.firm.should_not have_foreign_access  
        visit edit_lk_product_path(@lk_product)
        page.should have_no_selector "#lk_product_show_on_site"
        ForeignAccess.create(:name => "demo.giftb2b.ru", :param_key => "dsfds", :firm => @firm, :accepted_from => Date.yesterday, :accepted_to => Date.tomorrow)
        @lk_product.firm.should have_foreign_access
        visit edit_lk_product_path(@lk_product)
        page.should have_selector "#lk_product_show_on_site"
        page.should have_content "demo.giftb2b.ru"
      end
    end
    
   
end
