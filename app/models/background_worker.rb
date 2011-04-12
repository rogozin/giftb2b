class BackgroundWorker < ActiveRecord::Base
validates :current_status, :inclusion => {:in => %w( preparation start finish failed ) }
before_validation :init
  
  def failed(message)
    self.update_attributes({:current_status => "failed", :log_errors => message})
  end
  
  private
  
  def init
   self.current_status = "preparation" if self.new_record?
  end

end
