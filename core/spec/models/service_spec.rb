#encoding:utf-8;
require 'spec_helper'

describe Service do
  
  it 'После удаления услуги удаляются записи из service_roles' do
    service = Factory(:service)
    service.service_roles.create(:role_id => 12)
    service.destroy
    ServiceRole.all.should be_empty
  end
  
  
  it 'После удаления услуги у всех пользователей этой услуги удаляются роли' do
    role = Role.create("role-1")
    service = Factory(:service, :roles => [role])
    firm = Factory(:firm, :services => [service])
    user  =Factory(:user, :firm => firm)    
    service.destroy
    user.role_objects.should be_empty
  end
  
end
