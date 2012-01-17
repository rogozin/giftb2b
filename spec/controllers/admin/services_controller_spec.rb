#encoding:utf-8;
require 'spec_helper'

describe Admin::ServicesController do
before(:each) do
  direct_login_as :admin
end


  describe "GET 'index'" do
    it "should be successful" do
      service = Factory(:service)
      get 'index'      
      response.should be_success
      assigns(:services).should eq [service]
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end
  
  describe "POST 'create'" do
    it "creates a new service" do
       expect {
          post :create, :service => {:name => "УУУ"}
        }.to change(Service, :count).by(1)
      end    
      
    it "create should be successful" do
      post 'create', :service => {:name => "Услуга"}
      assigns(:service).should be_a(Service)
      assigns(:service).should be_persisted      
      response.should redirect_to edit_admin_service_path(assigns(:service))
    end
  end  

  describe "GET 'edit'" do
    it "should be successful" do
      service  = Factory(:service)
      get 'edit', :id => service.id
      assigns(:service).should eq service
      response.should be_success
    end
  end
  
  describe 'PUT Update' do
    it 'should update service' do
      service  = Factory(:service)
      put :update, :id => service.id, :service => {:name => "Новое название"}
      assigns(:service).name.should eq "Новое название"
      response.should redirect_to edit_admin_service_path(service)
    end
  end
  
  
  describe 'DELETE destroy' do
    it 'service should be destroyed' do
      service = Factory(:service)
      delete :destroy, :id => service.id
      assigns(:service).should be_destroyed
      response.should redirect_to admin_services_path
    end
  end
  

end
