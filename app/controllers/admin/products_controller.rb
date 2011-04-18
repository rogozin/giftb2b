require 'xml_download'

class Admin::ProductsController < Admin::BaseController
  access_control do
     allow :Администратор, "Редактор каталога"
  end
  
  def index 
    params[:page] || 1    
    if current_user.has_role?("Редактор каталога")  
      params[:supplier] = current_user.supplier ? current_user.supplier.id : -1
    end
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
    @product = Product.find(params[:id])
    @product.toggle! :active
  end
  
  def group_ops
    cnt = 0
    case params[:oper]
      when 'delete'
        params[:product_ids].split(',').each do |product_id|
          p = Product.find(product_id)
          cnt +=1 if p && p.destroy
          flash[:notice] = "Операция выполнена! Удалено #{cnt} позиций."
        end
      when 'copy'
         category  = Category.find(params[:category])
         params[:product_ids].split(',').each do |product_id|
          p = Product.find(product_id)
          cnt +=1 if p && category && p.category_ids.exclude?(category.id) && p.categories << category
          flash[:notice] = "Операция выполнена! Скопировано #{cnt} позиций в категорию \"#{category.name}\"."
        end
      when 'change'
        params[:product_ids].split(',').each do |product_id|
          p = Product.find(product_id)
          cnt +=1 if p && p.update_attribute(params[:property_name], params[:property_value])
          flash[:notice] = "Операция выполнена! Изменено #{cnt} позиций."
        end
    end
      params[:back_url] ? redirect_to( params[:back_url]) : redirect_to( admin_products_path)    
  end
  
end

