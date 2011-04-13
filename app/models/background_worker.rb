class BackgroundWorker < ActiveRecord::Base
<<<<<<< HEAD
validates :current_status, :inclusion => {:in => %w( preparation working finish failed ) }
=======
validates :current_status, :inclusion => {:in => %w( preparation start finish failed ) }
>>>>>>> 1fa700bb41f8fe77dcaa6019f44b230c43ce5684
before_validation :init
  
  def failed(message)
    self.update_attributes({:current_status => "failed", :log_errors => message})
  end
  
  private
  
  def init
   self.current_status = "preparation" if self.new_record?
  end

end
