require 'xml_download'

class Admin::ProductsController < Admin::BaseController
  access_control do
     allow :Администратор, "Редактор каталога"
  end
  
  def index 
    params[:page] || 1 
        
        respond_to do |format|
          format.html { @products  = Product.find_all(params) }
          format.xml {
                 @products  = Product.find_all(params) 
                render :xml => XmlDownload.get_xml(@products)                  
                }
        end
  end  
  

  def new
    @product = Product.new
  end

  def create
    params[:property_value_ids] ||=[]
    @product = Product.new(params[:product])
    if @product.save
      flash[:notice] = 'Новый товар успешно создан'
      redirect_to edit_admin_product_path(@product)
    else
      flash[:notice] = "Ошибка создания товара"
      render 'new'
    end
  end

  def edit
    @product = Product.find_by_permalink(params[:id])
  end

  def update
   params[:property_value_ids] ||=[]
    @product = Product.find_by_permalink(params[:id])
    if @product.update_attributes params[:product]
      flash[:notice] = 'Продукт успешно изменен'
      redirect_to edit_admin_product_path(@product)
    else
      flash[:notice] = "Ошибка изменения продута"
      render 'edit'
    end
  end

  def show
     @product = Product.find_by_permalink(params[:id])
  end

  def destroy
    @product = Product.find_by_permalink(params[:id])
    if  @product.destroy
      flash[:notice] = "Продукт удален"
      params[:back_url] ? redirect_to( params[:back_url]) : redirect_to( admin_products_path)
    end
  end

 def activate
    respond_to do |f|
      f.js {
            product = Product.find(params[:id])
            product.toggle! :active
            render :update do |page|
 page<< "$(\"#img_#{product.id}\").attr('src',\"#{image_path( product.active ? 'checked.gif' : 'unchecked.gif')}\");"
              
            end
          }
    end
  end
end

