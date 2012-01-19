#encoding: utf-8;
require 'spec_helper'

describe Firm do

  it 'permalink' do
    f = Firm.new(:name => "test", :short_name => "test1", :phone => "phone", :email => "email@example.com")
    f.should be_valid
    f.permalink.should eq("test1")
  end
  
  it 'lat & long values' do
    f = Factory.build(:firm)
    f.lat = -90
    f.long = -180
    f.should be_valid
    f.lat = -100
    f.long = -300
    f.should_not be_valid
    f.lat = 91
    f.long = 181    
    f.should_not be_valid
  end
  
  it 'after create should have default logo' do
    f = Factory(:firm)
    f.images.should have(1).record
  end
  
  it 'После удаления фирмы очищаются данные о услугах' do
   f = Factory(:firm)
   f.services << Service.create(:name => "Service")
   f.destroy
   FirmService.count.should be_zero
  end
  
  it 'После удаления фирмы пользователь превращается в конечного клиента' do
    pending
  end  
  

  
  describe 'Управление услугами' do
    before(:each) do
      @role = Role.create(:name => "lk_access", :description => "Доступ в линый кабинет", :group => 2)      
      @service  = Factory(:service, :roles => [@role])
      @firm = Factory(:firm)
      @user = Factory(:user, :firm_id => @firm.id)      
    end
    
    it 'firm services выбирает только активные услуги' do
      @firm.services <<  @service      
      @firm.services.should eq [@service]
      @firm.firm_services.first.destroy
      @firm.services.reload
      @firm.services.should be_empty
      @firm.firm_services.should have(1).record
    end
    
    it 'commit_service' do
      @firm.commit_service(@service)
      @firm.users.first.should have_role(@role.name)      
    end
    
    it 'фирма получает услугу' do
      @firm.services <<  @service
      @firm.users.first.should have_role(@role.name)
    end
    
    it 'отключаем услугу' do
      @firm.services <<  @service
      @firm.firm_services.first.destroy
      @user.role_objects.should be_empty
      @firm.archived_services.should eq [@service]
    end
    
    it 'Перекрестные роли' do
      @firm.services <<  @service
      service2 = Factory(:service, :name => "Доп. услуга", :roles => [@role, Role.create(:name => "Доп. допступ")])
      @firm.services <<  service2
      @firm.firm_services.last.destroy
      @user.should have_role(@role.name)
      @user.role_object_ids.should eq [@role.id]
    end
    
#    it 'меняем id фирмы у пользователя' do
#      Пока не реализовано
#      @firm.services <<  @service
#      role2 = Role.create(:name => "Доп. допступ")
#      service2 = Factory(:service, :name => "Доп. услуга", :roles => [role2])
#      firm2 = Factory(:firm, :services => [service2])
#      @user.update_attributes(:firm_id => firm2.id)
#      @user.role_object_ids.should eq [role2.id]
#    end
  end
  
end
