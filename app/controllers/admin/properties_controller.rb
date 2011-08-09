#encoding: utf-8;
class Admin::PropertiesController < Admin::BaseController
  access_control do
     allow :Администратор, "Редактор каталога"
  end
  
def index
  @properties = Property.all
  @property_values = PropertyValue.all
end

def new
  @property = Property.new
end

def create
  @property = Property.new params[:property]
  if @property.save
    flash[:notice] = "Свойство создано!"
    redirect_to admin_properties_path
  else 
    render 'new'
  end  
end

def edit
  @property=Property.find(params[:id])
  
end

def update
  @property = Property.find(params[:id])
  if @property.update_attributes params[:property]
    flash[:notice] = "Свойство изменено!"
    redirect_to admin_properties_path
  else 
    render 'edit'
  end  
end

def destroy
  p=Property.find(params[:id])
  p.destroy
  redirect_to admin_properties_path
end

  def show
    @property = Property.find(params[:id])
  end
  
  def load_filter_values
    @property = Property.find(params[:id])
    @selected = params[:selected]
    @check_box_name = params[:check_box_name] if params[:check_box_name].present?
  end

end
