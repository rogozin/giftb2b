#encoding:utf-8;

class Lk::ProfileController < Lk::BaseController
   access_control do
     allow :admin, :lk_supplier
  end
  
  before_filter :find_firm
  
  def edit
    
  end
  
  def update
    picture  = params[:firm].delete(:picture)
    if @firm.update_attributes params[:firm], :as => :supplier
      if picture
        @firm.images.delete_all
        AttachImage.create(:attachable => @firm, :image => Image.create(:picture => picture))
      end
      redirect_to profile_path, :notice => "Профиль компании успешно изменен"
    else
      render 'edit'
    end    
  end
  
  private 
  
  def find_firm
    @firm = current_user.firm
  end
  
end
