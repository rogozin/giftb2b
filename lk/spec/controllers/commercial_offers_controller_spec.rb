#encoding:utf-8;
require 'spec_helper'

describe Lk::CommercialOffersController do

  
  before(:each) do     
    direct_login_as :firm_manager
    @firm = Factory :firm
    @user.update_attribute :firm_id, @firm.id
  end
  
  context 'POST modify' do
    before(:each) do
      @commercial_offer = Factory(:commercial_offer, :firm => @user.firm)
      @co_item = @commercial_offer.commercial_offer_items.first
      @lk_product = @co_item.lk_product
    end
    
    it 'alert когда не передаем выбранные товары' do
      post :modify, {:id => @commercial_offer.id,  :delta => 10}
      flash[:alert].should_not be_nil
    end
    
    it 'изменение в рублях' do
      post :modify, {:id => @commercial_offer.id, :co_items => [@co_item.id], :delta => 10}      
      assigns(:commercial_offer).commercial_offer_items.first.lk_product.price.should eq @lk_product.price + 10
    end

    it 'изменение процентах' do
      post :modify, {:id => @commercial_offer.id, :co_items => [@co_item.id], :delta => 20, :unit => 1}      
      assigns(:commercial_offer).commercial_offer_items.first.lk_product.price.should eq @lk_product.price * 1.2
    end
    
    it 'Нанесение + изменение цены в рублях' do
      post :modify, {:id => @commercial_offer.id, :co_items => [@co_item.id], :logo => 5, :delta => 10}      
      assigns(:commercial_offer).commercial_offer_items.first.lk_product.price.should eq @lk_product.price + 15
    end

    it 'Нанесение + изменение цены в процентах' do
      post :modify, {:id => @commercial_offer.id, :co_items => [@co_item.id], :logo => 5, :delta => 20, :unit => 1}      
      assigns(:commercial_offer).commercial_offer_items.first.lk_product.price.should eq @lk_product.price * 1.2 + 5
    end        
    
    it 'скидочка' do
      post :modify, {:id => @commercial_offer.id, :co_items => [@co_item.id], :sale => 20}      
      assigns(:commercial_offer).commercial_offer_items.first.sale.should eq 20
    end            

    it 'когда меняю цену, скидочка не изменяется' do
      @commercial_offer.commercial_offer_items.first.update_attribute(:sale, 22)
      post :modify, {:id => @commercial_offer.id, :co_items => [@co_item.id], :delta => 10, :sale => ""}            
      assigns(:commercial_offer).commercial_offer_items.first.sale.should eq 22
    end            
    
  end
  
  
  context 'POST calculate' do
    before(:each) do
      @commercial_offer = Factory(:commercial_offer, :firm => @user.firm)
      @co_item = @commercial_offer.commercial_offer_items.first
      @lk_product = @co_item.lk_product
    end
    
    it 'пересчет' do
      post :calculate, {:id => @commercial_offer.id, :co_items => { @co_item.id => 4 } }
      assigns(:commercial_offer).commercial_offer_items.first.quantity.should eq 4
    end
    
    it 'если кол-во 0, товар будет удален из КП' do
      post :calculate, {:id => @commercial_offer.id, :co_items => { @co_item.id => 0 } }
      assigns(:commercial_offer).commercial_offer_items.should be_empty
    end    
    
    it 'если кол-во пусто, товар будет удален из КП' do
      post :calculate, {:id => @commercial_offer.id, :co_items => { @co_item.id => "" } }
      assigns(:commercial_offer).commercial_offer_items.should be_empty
    end        
  end
  
  
  context 'PUT update' do
    before(:each) do
      @commercial_offer = Factory(:commercial_offer, :firm => @user.firm)
    end
    
    it 'put update' do
      @lk_firm = Factory(:lk_firm, :firm_id => @user.firm_id)
      put :update, {:id => @commercial_offer.id, :commercial_offer => {:lk_firm_id => @lk_firm.id, :signature => "Комментарий"} }
      assigns(:commercial_offer).lk_firm_id.should eq @lk_firm.id
      assigns(:commercial_offer).signature.should eq "Комментарий"
    end
  end


end  
