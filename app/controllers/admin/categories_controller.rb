class Admin::CategoriesController < Admin::BaseController
  access_control do
     allow :Администратор, :Редактор
  end
  respond_to :html, :js
  before_filter :find_catalog_items, :only => [:catalog, :thematic, :analogs, :virtuals]
  
  def index
    
  end

  def catalog
       
  end
 
  def thematic
  end
  
  def analogs
  end
  
  def virtuals
  end
  
  def new
    @category = Category.new
    @category.parent_id = params[:parent_id] if params[:parent_id]
    @category.kind = params[:kind] if params[:kind]
  end

  def create
    @category = Category.new(params[:category])
    if @category.save      
      flash[:notice] = "Новая категория успешно создана" 
      expire_main_cache
      redirect_to edit_admin_category_path(@category)
    else
      render 'new'
    end  
  end

  def destroy
    @category = Category.find(params[:id])    
    expire_main_cache if @category.destroy
    @cat = get_catalog_items(@category.catalog_type)
    respond_to do |format|
      format.js {render  'reload' }
    end  
  end
  
  def edit
    @category = Category.find_by_permalink(params[:id])
  end
  
  def update
    @category = Category.find_by_permalink(params[:id])
    if @category.update_attributes(params[:category])
       expire_main_cache    
      redirect_to edit_admin_category_path(@category)
    end
  end
  
  def toggle_state
    @category  =Category.find(params[:id])
    @category.toggle! :active
    if request.xhr?      
      @cat = get_catalog_items(params[:action_name])
    else 
      flash[:notice] = "Состояние изменено!"      
      redirect_to send("admin_#{params[:action_name]}_path")
    end
  end
  
  def change_sort
    @category = Category.find(params[:id])
    @category.update_attribute :sort_order, params[:sort]    
    if request.xhr?      
      @cat = get_catalog_items(params[:action_name])
    else 
      flash[:notice] = "Порядок сортировки изменен"      
      redirect_to send("admin_#{params[:action_name]}_path")
    end
  end
  
  def add_image
    @category = Category.find_by_permalink(params[:id])
    @category.images.delete_all
    image = @category.images.new(params[:image])
    @category.save
    redirect_to edit_admin_category_path(@category)
  end
  
  def remove_image
     @category = Category.find_by_permalink(params[:id])   
     @category.images.delete_all    
     redirect_to edit_admin_category_path(@category)
  end
  
  def move
    @category = Category.find_by_permalink(params[:id])    
    @category_to = Category.find(params["move"]["category_to"])
    res = ProductCategory.update_all("category_id=#{@category_to.id}", "category_id=#{@category.id}")
    @category.update_attribute(:active, false)
    flash[:notice] = "#{res} товаров перемещено в категорию  <a href='#{edit_admin_category_path(@category_to)}'>#{@category_to.name}</a>"
    redirect_to edit_admin_category_path(@category)
  end
  
  def show_products_list    
    @category= Category.find(params[:id])
  end
     
  def change_category_products
    @category= Category.find(params[:id])
    if params[:commit] == "Изменить"
      if params[:category_products] and params[:category_products][:product_ids]
        flash[:notice] = "Изменения сохранены!" if  @category.update_attributes params[:category_products]
      else
        @category.product_ids = []
      end
    else
      @remote_category = Category.find(params[:remote_category_id])
      @remote_category.product_ids += params[:category_products][:product_ids]
      flash[:notice] = "Товары скопированы в категорию #{@remote_category.name}!"      
    end
    redirect_to edit_admin_category_path @category   
  end
    
  def child_items
    @category = Category.find(params[:id])
    @cat = @category.children
  end
  
  private 
  
  def find_catalog_items
    @cat = get_catalog_items(action_name) 
  end
  
  def get_catalog_items catalog_type
      case catalog_type
        when "catalog"
          Category.catalog.roots
        when "thematic"  
          Category.thematic.roots
        when "analogs"
          Category.analog.roots
        when "virtuals"
          Category.virtual.roots              
        else
          Catalog.roots                
      end
  end
  
end
