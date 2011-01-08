class Admin::PropertyValuesController < Admin::BaseController
  access_control do
     allow :Администратор, "Редактор каталога"
  end
  
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
  @property_value = PropertyValue.find(params[:id])
  
end

def update
 @property_value = PropertyValue.find(params[:id])
  if @property_value.update_attributes params[:property_value]
    flash[:notice] = "Значение изменено!"
    redirect_to admin_properties_path
  else 
    render 'edit'
  end  
end

def destroy
  p=PropertyValue.find(params[:id])
 flash[:notice] = "Значение удалено!" if  p.destroy
  redirect_to admin_properties_path
end

end
