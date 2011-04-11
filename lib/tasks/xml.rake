namespace :xml do
  desc "Upload all xml files in tmp/xmlupload directory. The name of file should be like supplier name in DB"  
  task :upload => :environment do
    STDERR.puts "*** The 'features' task is deprecated. See rake -T cucumber ***"
  end
end
