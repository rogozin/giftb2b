#encoding: utf-8;
#require 'xml_download'

class Admin::ProductsController < Admin::BaseController
  access_control do
     allow :Администратор, "Редактор каталога"
  end
  
  before_filter :find_properties, :only => [:new, :create, :edit, :update]
  before_filter :find_product, :only => [:show, :destroy, :edit, :update]
  before_filter :load_categories, :only => [:new, :create, :edit, :update]
  
  
  helper_method :product_fields, :product_fields_session
  
  def index 
    set_default_fields
    params[:page] || 1    
    @properties = Property.active.for_search
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

  end

  def update
   params[:property_value_ids] ||=[]
   @product.store_units.clear
    if @product.update_attributes params[:product]
      if params[:store_unit].present?
        added_stores = []
        params[:store_unit][:store_id].each_with_index do |store_id, index|            
            unless added_stores.include?(store_id)
              @product.store_units.create(:store_id => store_id, :count => params[:store_unit][:count][index])    
              added_stores << store_id
            end
        end
      end
      flash[:notice] = 'Продукт успешно изменен'
      redirect_to edit_admin_product_path(@product)
    else
      flash[:notice] = "Ошибка изменения продута"
      render 'edit'
    end
  end

  def show
  end

  def destroy
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
          if params[:property_values].present?
            params[:property_values].each do |p_value_id|
              begin
                ProductProperty.create(:property_value_id => p_value_id, :product_id => product_id)
                cnt += 1
              rescue => err
                logger.info("dublicate key #{err}")
              end
            end          
          else
            p = Product.find(product_id)
            cnt +=1 if p && p.respond_to?(params[:property_name]) && p.update_attribute(params[:property_name], params[:property_value])
          end
          flash[:notice] = "Операция выполнена! Изменено #{cnt} позиций."
        end
    end
      redirect_to_back   
  end

  def fields_settings 
    if params[:fields_settings].present?
      session[:product_fields_settings] = {} 
      params[:fields_settings].each do |field|
        session[:product_fields_settings][field.to_sym] = true
      end
    end    
    redirect_to_back
  end
  
  def inline_property_values
    @product = Product.find(params[:id])
    @property = Property.find(params[:property_id])
    
  end
  
  def update_inline
    params[:property_values] ||=[]
    @product = Product.find(params[:id])
    @property = Property.find(params[:property_id])    
    @product.product_properties.joins(:property_value).where("property_values.property_id" => @property.id).each do |pp| 
      pp.destroy
    end
    params[:property_values].each do |property_value_id|
      @product.product_properties.create(:property_value_id => property_value_id)  
    end
  end

  private
  
  def find_product
    @product = Product.find_by_permalink(params[:id])    
  end

  
  def redirect_to_back
    params[:back_url] ? redirect_to( params[:back_url]) : redirect_to( admin_products_path) 
  end

  def find_properties
    @properties = Property.active
  end

  def product_fields
    standart = {:image => "Изображение", :code => "Код", :category => "Категория", :manufactor => "Производитель", :supplier => "Поставщик", :article => "Артикул", :short_name => "Название", :price => "Цена", :active => "П?", :store_count => "К-во на складе", :color => "Цвет(П)", :factur => "Материал(П)", :box => "Упаковка", :size => "Размер", 
    :new => "Новинка", :sale => "Распродажа", :best_price => "Лучшая цена", :sort_order => "Сортировка" }
    Property.active.each do |prop|
      standart["property_#{prop.id}".to_sym] = prop.name
    end
    standart
  end

  def set_default_fields
     session[:product_fields_settings] ||= {:image => true, :code => true, :category => true, :manufactor => true, :supplier => true, :article => true, :short_name => true, :price => true, :active => true, :store_cont => true}

  end
  
  def product_fields_session
    session[:product_fields_settings]
  end
  
  def load_categories
    @catalog = Category.catalog_tree(Category.catalog)
    @analogs = Category.catalog_tree(Category.analog)
    @thematic = Category.catalog_tree(Category.thematic)   
  end

  
end

