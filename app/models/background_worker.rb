#encoding: utf-8;
class BackgroundWorker < ActiveRecord::Base
validates :current_status, :inclusion => {:in => %w( preparation working finish failed stoping stop ) }
before_validation :init
  
  def failed(message)
    self.update_attributes({:current_status => "failed", :log_errors => message})
  end
  
  def self.clear
    where(:current_status => [:preparation, :working]).delete_all
  end
  
  private
  
  def init
   self.current_status = "preparation" if self.new_record?
  end

end
