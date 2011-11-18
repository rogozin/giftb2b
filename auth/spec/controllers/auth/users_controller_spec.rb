#encoding: utf-8;
require 'spec_helper'

describe Auth::UsersController do
  describe "POST Create" do
    it "регистрация" do
       post :create, {:i_am => 1, :user => {:fio => "Вася", :company_name => "Рога и рога", :city => "Москва", :phone => "32423423423", :appoint => "Електрик", :url => "http://www.yandex.ru", :email => "vasya@giftb3.ru" }, :use_route => :auth_engine}
       
       assigns(:user).should be_persisted
       assigns(:user).should be_a(User)
       assigns(:firm).should be_a(Firm)
       assigns(:firm).should be_persisted
       assigns(:firm).state_id.should eq 3
       assigns(:firm).city.should eq assigns(:user).city
       assigns(:firm).url.should eq assigns(:user).url
       assigns(:firm).phone.should eq assigns(:user).phone
       assigns(:firm).email.should eq assigns(:user).email
      response.should be_success
    end
  end
end
