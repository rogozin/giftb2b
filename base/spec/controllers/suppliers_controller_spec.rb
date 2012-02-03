#encoding: utf-8;
require 'spec_helper'

describe SuppliersController do
#  render_views
#  let(:page) { Capybara::Node::Simple.new(@response.body) }
  
  describe "GET Show" do
    before(:each) do      
      @category = Factory(:category)
      @s1= Factory(:supplier)
    end
    
    it 'Пользователь личного кабинета может открыть любого поставщика' do
      direct_login_as :firm_manager
      get :show, :id => @s1.permalink
      response.should be_success
      assigns(:supplier).should eq @s1
    end
    
    context 'Роль Личный кабинет поставщика' do
      before(:each) do
        @s2 = Factory(:supplier)
        direct_login_as :user 
        Factory(:firm, :users => [@user], :supplier_id => @s2.id)           
        @user.has_role!(:lk_supplier)
      end      
    
      it 'может посмотреть себя' do
        @user.has_role!(@s2.name, @s2)
        get :show, :id => @s2.permalink
        response.should be_success     
        assigns(:supplier).should eq @s2 
      end
      
      it 'при попытке открыть чужого поставщика - открывается свой' do
        @user.has_role!(@s2.name, @s2)
        get :show, :id => @s1.permalink
        response.should be_success     
        assigns(:supplier).should eq @s2                
      end
      
    end
    
  end
end
