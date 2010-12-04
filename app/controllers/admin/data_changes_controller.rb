class Admin::DataChangesController < Admin::BaseController
  access_control do
     allow :Администратор
  end
after_filter :wrap_ajax_file_upload_responce, :only => [:create]
respond_to :html, :js
  
  def index
    @workers = BackgroundWorker.all(:limit=>5, :order => "id desc")
    @suppliers = Supplier.all
    @last_bw = find_bw
    @can_upload = @last_bw.blank? || !@last_bw.task_end.blank? 
  end
  
  def create
    f=params[:import_data][:xml_file]
    if f.blank?
      flash[:error] = "Файл не выбран"
      redirect_to admin_data_changes_path
      return true
    end  
    pr_images = params[:import_data][:process_images] || false
    Product.update_all("active = 0", ["supplier_id in (?)",params[:import_data][:suppliers] ])
    Delayed::Job.enqueue(ProcessingJob.new(f.tempfile.path,f.original_filename, current_user.id, pr_images))    
 end
  
  
  def get_status
    bw = find_bw
    state = get_text_state(bw)
    unless bw.task_end
      render :text => "Статус: #{state}<br/>Обработано #{bw.current_item}<br/>Ошибки: #{bw.log_errors}"
    else
      render :text => "Обработка завершена!"
    end
#    render :update  do |page| 
#      unless bw.task_end
#        page.replace_html :messages, "Статус: #{state}"
#        page.replace_html :progress, "обработано  #{bw.current_item} из #{bw.total_items}" 
#        page.replace_html :errors, bw.log_errors        
 #     else        
#        page.replace_html :call_remote, ""
#        page<< "allow_pcr = false;"
#        page.replace_html :messages, "Обработка завершена."
#      end
#    end
  end
  
   def cancel_thread
    bw = BackgroundWorker.last   
    bw.update_attribute :current_status, "stoping"
    render :update  do |page|       
        page.replace_html :messages, "Отменяю обработку..."
    end
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
  
  def wrap_ajax_file_upload_responce
    response.content_type = nil
    response.body = "<textarea>#{response.body}</textarea>"
  end
  
end
