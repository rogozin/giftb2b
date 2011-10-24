#encoding: utf-8;
class Admin::DataChangesController < Admin::BaseController
  access_control do
     allow :Администратор
  end
#after_filter :wrap_ajax_file_upload_responce, :only => [:create]
respond_to :html, :js
  
  def index
    find_workers
    @suppliers = Supplier.all
    @bw = find_bw
    @can_upload = @bw.blank? || !@bw.task_end.blank? 
  end
  
  def create
    f=params[:import_data][:xml_file]
    if f.blank?
      flash[:alert] = "Файл не выбран"
      redirect_to admin_data_changes_path
      return true
    end  
    pr_images = params[:import_data][:process_images] || false
    reset_images = params[:import_data][:reset_images] || false  
    reset_properties = params[:import_data][:reset_properties] || false  
    Product.update_all("active = 0", ["supplier_id in (?)",params[:import_data][:suppliers] ])
    Delayed::Job.enqueue(ProcessingJob.new(f.tempfile.path,f.original_filename, current_user.id, pr_images, reset_images, reset_properties))    
    sleep 2
    redirect_to admin_data_changes_path
 end
  
  
  def get_status
    @bw = find_bw
    state = get_text_state(@bw)
    unless @bw.task_end
      render :text => "Статус: #{state}<br/>Обработано #{@bw.current_item}<br/>Ошибки: #{@bw.log_errors}"
    else
      render :text => "Обработка завершена!"
    end
  end
  
  def stop
    bw = BackgroundWorker.find(params[:id])   
    if bw.current_status == "working"      
      bw.update_attributes(:current_status =>  "stoping")            
      render  "cancel.js"
    else
      bw.update_attributes(:current_status =>  "stop",:task_end => Time.now)            
      find_workers
    end
  end
  
   def cancel_thread
    bw = BackgroundWorker.last   
  end 
  
  protected
    def get_text_state(bw)
    case bw.current_status
      when "preparation"
        "подготовка"
      when "working"  
        "обработка"
      when "stoping"
        "остановка"
      when "stop"    
        "остановлен"
      when "finish"
        "завершен"
      else 
        "не определен"     
    end
  end 
  
  private
  

 
  def find_bw
    BackgroundWorker.find_last_by_user_id(current_user.id)
  end
  
  def find_workers
        @workers = BackgroundWorker.all(:limit=>30, :order => "id desc")
  end
  
  def wrap_ajax_file_upload_responce
    response.content_type = nil
    response.body = "<textarea>#{response.body}</textarea>"
  end

end
