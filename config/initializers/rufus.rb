require 'rubygems'
require 'rufus/scheduler'  
scheduler = Rufus::Scheduler.start_new
scheduler.cron "* * * * *" do
  SampleNotificationJob.new.perform
end
