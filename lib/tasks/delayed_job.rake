namespace :jobs do
  desc "Clear the delayed_job && backgroundworker queue"
  task :empty => :environment do
     BackgroundWorker.clear    
    Delayed::Job.delete_all
  end
end  
