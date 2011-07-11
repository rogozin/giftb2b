puts __FILE__
require 'clockwork'
require File.expand_path('../../config/boot.rb', __FILE__)
require File.expand_path('../../config/environment.rb', __FILE__)
require 'processing_job'
#require 'config/boot'
#require 'config/environment'


every(1.day, 'SampleNotification.job', :at => '07:00') { Delayed::Job.enqueue(SampleNotificationJob.new)}
