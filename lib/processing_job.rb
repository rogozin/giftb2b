class ProcessingJob < Struct.new(:path,:filename,:user_id,:process_images, :reset_images)  
  def perform  
    bw=BackgroundWorker.create(:task_name => filename, :current_status =>"preparation", :user_id => user_id)
    XmlUpload.process_file(path, bw.id, process_images, reset_images)
  end  
end  
