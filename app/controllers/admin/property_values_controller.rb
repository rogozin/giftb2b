#encoding: utf-8;
class Admin::PropertyValuesController < Admin::BaseController
  access_control do
     allow :Администратор, "Редактор каталога"
  end

  before_filter :find_pv, :only => [:edit, :update, :destroy, :show]
  
  def new
    @property = Property.find(params[:property_id])
    @property_value = PropertyValue.new(:property_id=> @property.id)
  end

  def create
    @property_value = PropertyValue.new params[:property_value]
    if @property_value.save
      flash[:notice] = "Значение создано!"
      redirect_to admin_properties_path
    else 
      render 'new'
    end  
  end

  def edit
  end

  def update
  if @property_value.update_attributes params[:property_value]
    flash[:notice] = "Значение изменено!"
    redirect_to admin_properties_path
  else 
    render 'edit'
  end  
end

  def destroy
    flash[:notice] = "Значение удалено!" if  @property_value.destroy
    redirect_to admin_properties_path
  end

  def show
    params[:page] ||=1     
    @products = @property_value.products.paginate(:page => params[:page])
  end

  private
  
  def find_pv
     @property_value = PropertyValue.find(params[:id])
  end

end
