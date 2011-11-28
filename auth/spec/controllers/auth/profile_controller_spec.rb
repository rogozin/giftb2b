#encoding: utf-8;
require 'spec_helper'

describe Auth::ProfileController do
  render_views
  let(:page) { Capybara::Node::Simple.new(@response.body) }
  
  it 'Пользователь фирмы не может изменить свой логин' do
    direct_login_as :firm_manager
    get :edit, {:use_route => :auth_engine}
    assigns(:account).should eq @user
    page.should have_no_selector "#user_username"    
    
  end
  
  it 'Конечный пользователь может изменить свой логин' do
    direct_login_as :simple_user
    get :edit, {:use_route => :auth_engine}
    assigns(:account).should eq @user
    page.should have_selector "#user_username"    
  end  
  
end
