#encoding:utf-8;
require 'spec_helper'

describe FirmService do
  
  it 'Активные записи' do
    FirmService.create(:firm_id => 1, :service_id => 1)
    FirmService.create(:firm_id => 1, :service_id => 2, :deleted_at => Time.now )    
    FirmService.active.should have(1).records       
  end
  
  it 'Неактивные записи' do
    FirmService.create(:firm_id => 1, :service_id => 1)
    FirmService.create(:firm_id => 1, :service_id => 2, :deleted_at => Time.now )    
    FirmService.history.should have(1).records       
  end
  
  it 'При удалении записи проставляется только deleted_at' do
    fs = FirmService.create(:firm_id => 1, :service_id => 1)
    fs.destroy
    fs.deleted_at.should be_present
    fs.should be_persisted
  end
    
end
