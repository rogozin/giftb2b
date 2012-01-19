#encoding:utf-8;
require 'spec_helper'

describe Service do
  
  before(:each) do
    @service = Factory(:service)
    @firm = Factory(:firm, :services => [@service])
    @user = Factory(:user, :firm => @firm)        
    @role = Role.create(:name => "role-1")
  end
  
 
  it 'После удаления услуги удаляются записи из service_roles' do    
    @service.roles << @role    
    @service.service_roles.create(:role => Role.create(:name => "test-role"))
    @service.destroy
    ServiceRole.all.should be_empty
  end


  it 'После удаления услуги удаляются записи из firm_services' do    
    @service.roles << @role    
    @service.destroy
    FirmService.all.should be_empty
  end
      
  it 'После удаления услуги у всех пользователей этой услуги удаляются роли' do
    @service.roles << @role    
    @service.destroy
    @user.role_objects.should be_empty
  end
  
  it 'Когда к услуге добавляем роль, все пользователи этой услуги получают эту роль' do
    @service.roles << @role    
    @user.role_object_ids.should eq [@role.id]
  end
  
end
