require 'rubygems'
require 'rufus/scheduler'  
scheduler = Rufus::Scheduler.start_new
scheduler.cron "0 7 * * *" do
  safely do
      SampleNotificationJob.new.perform
  end
end

 def safely
      begin
        unless ActiveRecord::Base.connected?
          ActiveRecord::Base.connection.verify!(0)
        end
        yield
      rescue => e
        #status e.inspect
        puts "err: #{e.message}"
      ensure
        ActiveRecord::Base.connection_pool.release_connection
      end
    end
