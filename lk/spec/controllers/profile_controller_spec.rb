#encoding:utf-8;
require 'spec_helper'

describe Lk::ProfileController do
  
  before(:each) do     
    direct_login_as :supplier_manager
    @firm = @user.firm
  end

  it 'GET edit' do
    get :edit, {:use_route => :lk_engine}
    response.should be_success
    assigns(:firm).should eq @firm
  end
  
  it 'trying to open profile without lk_supplier' do
    @user.role_objects.clear
    get :edit, {:use_route => :lk_engine}
    response.should redirect_to "/auth/login"
  end
  
  it 'SAVE PROFILE' do
    put :update, {:firm => {:name => "The Best", :addr_f => "Москва", :description => "Company"}, :use_route => :lk_engine}
    response.should redirect_to "/lk/profile"
    assigns(:firm).should eq @firm
    flash[:notice].should be_present
  end

  it 'check mass-assignment' do
    put :update, {:firm => {:short_name => "changed", :show_on_site => true}, :use_route => :lk_engine}
    response.should redirect_to "/lk/profile"
    assigns(:firm).should eq @firm
    
  end
    

end

