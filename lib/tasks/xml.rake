namespace :xml do
  desc "Upload all xml files in tmp/xmlupload directory. The name of file should be like supplier name in DB"  
  task :upload => :environment do
    XmlUpload.process_files nil
  end

  desc "Clear tmp/xmlupload directory"
  task :clear => :environment do
    XmlUpload.clear_dirs
  end
end
