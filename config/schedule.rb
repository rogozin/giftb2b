# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
set :output, "log/cron_log.log"

job_type :runner,  "cd :path && rvm use 1.9.2 && script/rails runner -e :environment ':task' :output"

#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
 every 1.day, :at => "11:00 am" do
   runner "SampleNotificationJob.new.perform"
 end

# Learn more: http://github.com/javan/whenever
