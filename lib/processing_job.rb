#encoding: utf-8;
class ProcessingJob < Struct.new(:path,:filename,:user_id,:process_images, :reset_images, :reset_properties)  
  def perform  
    bw=BackgroundWorker.create(:task_name => filename, :user_id => user_id)
    puts "var process_images=#{process_images}"
    XmlUpload.process_file(path, bw.id, {:import_images => process_images, :reset_images => reset_images, :reset_properties => reset_properties})
  end  
end  

