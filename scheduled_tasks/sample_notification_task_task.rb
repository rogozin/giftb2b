class SampleNotificationTaskTask < Scheduler::SchedulerTask
  environments :all
  # environments :staging, :production
  
  #every '1d', :first_at => '11:28'
  cron '30 11 * * *'  
  # other examples:
  # every '24h', :first_at => Chronic.parse('next midnight')
  # cron '* 4 * * *'  # cron style
  # in '30s'          # run once, 30 seconds from scheduler start/restart
  
  
  def run
    # Your code here, eg: 
    # User.send_due_invoices!
    
    # use log() for writing to scheduler daemon log
    Delayed::Job.enqueue(SampleNotificationJob.new)
    log("samples notification message send")
  end
end
