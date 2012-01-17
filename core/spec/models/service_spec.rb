#encoding:utf-8;
require 'spec_helper'

describe Service do
  
  it 'После удаления услуги удаляются записи из service_roles' do
    service = Factory(:service)
    service.service_roles.create(:role_id => 12)
    service.destroy
    ServiceRole.all.should be_empty
  end
  
end
