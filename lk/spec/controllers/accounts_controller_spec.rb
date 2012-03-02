#encoding:utf-8;
require 'spec_helper'

describe Lk::AccountsController do
  render_views
  let(:page) { Capybara::Node::Simple.new(@response.body) }  
  
  before(:each) do     
    direct_login_as :user
    @user.role_objects << Factory(:r_admin)
    @role = Factory :r_search
    @service = Factory :service, :roles => [@role]
    @firm = Factory :firm, :services => [@service]
    @user.update_attribute :firm_id, @firm.id    
  end
  
  def valid_attributes
    {:user => {:fio => "Вася",  :phone => "32423423423", :cellphone => "+7 903 102-34-23", :appoint => "Електрик", :email => "vasya@giftb3.ru" }}    
  end
  
  describe 'GET New (new user)' do
    it 'new user template' do
      get :new
      assigns(:account).should be_a_new(User)
      response.should render_template(:new)
    end
    
    it 'passwords fields should be disabled' do
      get :new
      page.should have_no_selector "#user_username"
      page.should have_no_selector "#user_password"
      page.should have_no_selector "#user_password_confirmation"
    end
  end
 
  describe 'GET Edit (edit user)' do
   before(:each) do
      @account = Factory(:firm_user, :firm_id => @firm.id)
   end

   it 'edit template' do
      get :edit, :id => @account.id
      response.should render_template(:edit)     
   end
   
    it 'passwords fields should be enabled' do
      get :edit, :id => @account.id
      page.should have_no_selector "#user_username"
      page.should have_selector "#user_password"
      page.should have_selector "#user_password_confirmation"
    end
  end

  
  describe 'POST Create' do
    it 'should render password page' do      
      post :create, valid_attributes
      assigns(:password).should be_a(String)
      response.should render_template(:account)
    end
        
    it 'create new (the first) user' do
      next_username = User.next_username(@firm.id)
      post :create, valid_attributes
      assigns(:account).should be_a(User)
      assigns(:account).should be_persisted
      assigns(:account).username.should eq next_username
      assigns(:account).role_objects.should eq [@role]
    end
    
    it 'next user should have prior username index + 1' do
      Factory(:firm_user, :firm_id => @firm.id, :username => "f#{@firm.id}.1")
      next_username = User.next_username(@firm.id)
      post :create, valid_attributes
      assigns(:account).username.should eq next_username
      assigns(:account).username.should eq "f#{@firm.id}.2"     
    end    
  end  
end
