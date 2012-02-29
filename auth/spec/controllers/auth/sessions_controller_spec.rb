#encoding: utf-8;
require 'spec_helper'

describe Auth::SessionsController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it 'log in' do
    get "new", {:use_route => :auth_engine}
    response.code.should eq "200"
  end
  
  it 'wrong params' do
    post :create,  {:user => {:user_name => "aaa", :password => "bbb"},:use_route => :auth_engine }
    response.code.should eq "200"
    flash[:alert].should_not be_nil
  end

  it 'wrong username' do
    post :create,  {:user => {:login => "aaa", :password => "bbb"},:use_route => :auth_engine }
    response.code.should eq "200"
    flash[:alert].should_not be_nil
  end

  it 'successfull login' do
    user = Factory(:user, :password => "test")
    post :create,  {:user => {:login => user.username, :password => "test"},:use_route => :auth_engine }
    response.code.should eq "302"
    flash[:alert].should be_nil
    flash[:notice].should_not be_nil
  end
  
  it 'Пользователь фирмы должен быть перенаправлен на гифтпоиск' do
    user = Factory(:firm_manager, :password => "test")
    post :create,  {:user => {:login => user.username, :password => "test"},:use_route => :auth_engine }
    response.code.should eq "302"
    response.should redirect_to("http://giftpoisk.ru/?token=#{user.authentication_token}")
  end

  it 'Если логин на гифтпоиске, редирект на главную страницу.' do
    user = Factory(:firm_manager, :password => "test")
    Settings.stub(:giftpoisk?).and_return(true)
    Settings.stub(:giftb2b?).and_return(false)
    post :create,  {:user => {:login => user.username, :password => "test"},:use_route => :auth_engine }
    response.code.should eq "302"
    response.should redirect_to("/")
  end


  it 'вход по токену' do
    user = Factory(:user, :password => "test")    
    old_token = user.authentication_token
    get "new", {:token => user.authentication_token ,:use_route => :auth_engine }
    subject.current_user.should_not be_nil 
    subject.user_signed_in?.should be_true
    response.code.should eq "302"
    response.should redirect_to("/")    
    user.reload
    user.authentication_token.should_not eq old_token
  end

end
