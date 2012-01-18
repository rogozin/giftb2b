class FirmService < ActiveRecord::Base
  belongs_to :firm
  belongs_to :service
  set_primary_keys :firm_id, :service_id
  
  scope :active, where("deleted_at is null")
  scope :history, where("deleted_at is not null")  
  after_create :flush_service
  
  def destroy
    self.update_attribute :deleted_at, Time.now
  end
  
  private
  
  def flush_service
    firm.commit_service(service)
  end
  
end
