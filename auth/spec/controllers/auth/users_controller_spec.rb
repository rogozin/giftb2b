#encoding: utf-8;
require 'spec_helper'

describe Auth::UsersController do
  
  def valid_attributes
    {:i_am => 1, :user => {:fio => "Вася", :company_name => "Рога и рога", :city => "Москва", :phone => "32423423423", :appoint => "Електрик", :url => "http://www.yandex.ru", :email => "vasya@giftb3.ru" }, :use_route => :auth_engine}
  end
  
  describe "POST Create" do
    it "регистрация рекламного агентства" do
       post :create, valid_attributes       
       assigns(:user).should be_persisted
       assigns(:user).should be_a(User)
       assigns(:firm).should be_a(Firm)
       assigns(:firm).should be_persisted
       assigns(:firm).state_id.should eq 3
       assigns(:firm).city.should eq assigns(:user).city
       assigns(:firm).url.should eq assigns(:user).url
       assigns(:firm).phone.should eq assigns(:user).phone
       assigns(:firm).email.should eq assigns(:user).email       
       assigns(:user).expire_date.should eq Date.today.next_day(5)
       assigns(:user).username.should eq "f#{assigns(:firm).id}.1"       
       response.should be_success
    end
    
    it "регистрация конечного клиента" do
       post :create, valid_attributes.merge(:i_am => 0)      
       assigns(:user).should be_persisted
       assigns(:user).should be_a(User)
       assigns(:firm).should be_nil
       assigns(:user).expire_date.should be_nil
       assigns(:user).username.should eq "vasya"       
       response.should be_success
    end    
    
  
    it "когда фирма уже есть" do
      firm = Factory(:firm, :name => valid_attributes[:user][:company_name])
      post :create, valid_attributes       
      assigns(:firm).name.should eq valid_attributes[:user][:company_name] + "-1"
      assigns(:firm).users.should eq [assigns(:user)]
    end
    
    it "когда пермалинк уже есть" do
      firm = Factory(:firm, :name => "Крутая фирма", :permalink => "roga-i-roga")
      post :create, valid_attributes       
      assigns(:firm).should be_persisted
    end
  end
end
