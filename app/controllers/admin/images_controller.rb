#encoding: utf-8;
class Admin::ImagesController < Admin::BaseController

  access_control do
     allow :admin, :admin_catalog
  end
    
  def all
    params[:page] ||=1
    @images= Image.paginate(:page=>params[:page])
  end
  
  def index
    if params[:product_id]
      @product= Product.find_by_permalink(params[:product_id])
    end
  end

  def create
    product = Product.find_by_permalink(params[:product_id])
    if AttachImage.create(:attachable => product, :image => Image.create(params[:image]))
      flash[:notice] = "Изображение успешно сохранено"
    else
      flash[:alert] = "Ошибка добавленя изображения!"
    end
    redirect_to admin_product_images_path(params[:product_id])
  end


  def destroy
     image=Image.find(params[:id])
     flash[:notice] = "Изображение удалено" if image.destroy     
     redirect_to all_admin_images_path(params[:product_id])
  end
  
  def remove
    product = Product.find_by_permalink(params[:product_id])
    #flash[:notice] = "Изображение исключено из товара, но осталось на сервере" if product.images.delete(Image.find(params[:id]))
    image = Image.find(params[:id])
   flash[:notice] = "Изображение отвязано от товара" if product.images.delete(image) 
    redirect_to admin_product_images_path(params[:product_id])
  end
  
  def set_main
    @product = Product.find(params[:product_id])
    attach_image = @product.attach_images.find_by_image_id(params[:id])    
    @product.touch if attach_image.toggle! :main_img    
    respond_to do |format|
      format.js {render 'reload_images'}
      format.html {redirect_to admin_product_images_path(@product)}
    end
  end
  
end

