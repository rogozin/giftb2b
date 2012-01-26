#encoding: utf-8;
require 'spec_helper'

describe Auth::UserSessionController do

  it 'log in' do
    get "new", {:use_route => :auth_engine}
    assigns(:user_session).should be_a_new(UserSession)
    response.code.should eq "200"
  end
  
  
  it 'wrong params' do
    post :create,  {:user_session => {:user_name => "aaa", :password => "bbb"},:use_route => :auth_engine }
    response.code.should eq "302"
    flash[:login_error].should_not be_nil
    flash[:alert].should_not be_nil
  end

  it 'wrong username' do
    post :create,  {:user_session => {:username => "aaa", :password => "bbb"},:use_route => :auth_engine }
    response.code.should eq "302"
    flash[:alert].should_not be_nil
  end


  it 'successfull login' do
    user = Factory(:user, :password => "test")
    post :create,  {:user_session => {:username => user.username, :password => "test"},:use_route => :auth_engine }
    response.code.should eq "302"
    flash[:login_error].should be_nil
    flash[:alert].should be_nil
  end
  
  it 'Пользователь фирмы должен быть перенаправлен на гифтпоиск' do
    user = Factory(:firm_manager, :password => "test")
    post :create,  {:user_session => {:username => user.username, :password => "test"},:use_route => :auth_engine }
    response.code.should eq "302"
    flash[:login_error].should be_nil
    user.reload
    response.should redirect_to("http://giftpoisk.ru/auth/login/#{user.perishable_token}")
  end

  it 'Если логин на гифтпоиске, редирект на главную страницу.' do
    user = Factory(:firm_manager, :password => "test")
    Settings.stub(:giftpoisk?).and_return(true)
    Settings.stub(:giftb2b?).and_return(false)
    post :create,  {:user_session => {:username => user.username, :password => "test"},:use_route => :auth_engine }
    response.code.should eq "302"
    flash[:login_error].should be_nil
    response.should redirect_to("/")
  end


end
