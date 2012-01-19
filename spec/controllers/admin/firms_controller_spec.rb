#encoding:utf-8;
require 'spec_helper'

describe Admin::FirmsController do
before(:each) do
  direct_login_as :admin
  @firm =  Factory(:firm)
  @user = Factory(:user, :firm_id => @firm.id)
  @role = Role.create(:name => "role")
  @service = Factory(:service, :roles => [@role])
end


  it 'GET edit' do
    get :edit, :id => @firm.id
    assigns(:firm).should eq @firm
    assigns(:services).should eq [@service]
    response.should be_success    
  end
  
  it 'GET new' do
    get :new
    assigns(:firm).should be_a_kind_of(Firm)
    assigns(:firm).should be_new_record
    assigns(:services).should eq [@service]    
    response.should be_success    
  end
  
  it 'POST create' do
    post :create, :firm => {:name => "ООО-1", :email => "my-company@email.com", :phone => "01234567", :service_ids => [@service.id]}
    assigns(:firm).should be_persisted
    assigns(:firm).services.should eq [@service]
    #@user.role_object_ids.should eq [@role.id]
    response.should redirect_to edit_admin_firm_path(assigns(:firm))
  end
  
  context "PUT update" do 
  
    it 'update should successfull' do
      put :update, :id => @firm.id, :firm => {:name => "OOO-OOO", :service_ids => [@service.id]}
      assigns(:firm).should be_persisted
      assigns(:firm).services.should eq [@service]
      @user.role_object_ids.should eq [@role.id]
      response.should redirect_to edit_admin_firm_path(assigns(:firm))       
    end
    
    it 'disable service' do
      @firm.services << @service
      put :update, :id => @firm.id, :firm => {:service_ids => []}
      assigns(:firm).services.should be_empty
      assigns(:firm).archived_services.should eq [@service]
      @user.role_object_ids.should be_empty
    end
  end

  it 'DELETE destroy' do
    delete :destroy, :id => @firm.id
    assigns(:firm).should be_destroyed
    assigns(:firm).services.should be_empty
    response.should redirect_to admin_firms_path
  end

end
