#encoding: utf-8;
class Admin::ContentImagesController < Admin::BaseController
  access_control do
     allow :admin, :admin_content
  end
  
  def index
    @content_images = ContentImage.paginate(:page => params[:page] || "1", :per_page => 40, :order => "created_at desc")
  end
  
  def create
    @content_image = ContentImage.new(params[:image])
    if @content_image.save      
      redirect_to admin_content_images_path, :notice => "Изображение добавлено!"
    else
      flash[:alert] = "Ошибка добавления изображения"
      render 'index'
    end
  end
  
  def destroy
    @content_image = ContentImage.find(params[:id])
    flash[:notice] = "Изображение удалено" if @content_image.destroy
    redirect_to admin_content_images_path
  end
  
  def galery
    @content_images = ContentImage.paginate(:page => params[:page] || "1", :per_page => 20, :order => "created_at desc")
    render :layout => false
  end

end
