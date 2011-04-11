class BackgroundWorker < ActiveRecord::Base

before_create :init

  private
  def init
   self.current_status = "preparation" 
  end

end
