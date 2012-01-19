class FirmService < ActiveRecord::Base
  belongs_to :firm
  belongs_to :service
  set_primary_keys :firm_id, :service_id
  
  scope :active, where("deleted_at is null")
  scope :history, where("deleted_at is not null")  
  after_create  {|record| record.firm.commit_service(record.service) }
  
  def destroy
    firm.rollback_service(service)    
    update_attribute :deleted_at, Time.now
  end
end
