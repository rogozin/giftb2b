#encoding: utf-8;
class Admin::PropertyValuesController < Admin::BaseController
  access_control do
     allow :Администратор, "Редактор каталога"
  end

  before_filter :find_pv, :only => [:edit, :update, :destroy, :show, :join]
  before_filter :load_properties, :only => [:edit, :update, :join]
  
  
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
  
  def join
    errs = 0
    total = 0
    value_names = []
    params[:property_values].each do |value_id|
      val = PropertyValue.find(value_id)
      value_names << val.value
      @property_value.product_properties.each do |pp|
        begin
          total += 1 if ProductProperty.create(:property_value_id => value_id, :product_id => pp.product_id)
        rescue
          errs +=1
        end
      end
    end
    ProductProperty.where(:property_value_id => @property_value.id).delete_all
    redirect_to edit_admin_property_value_path(@property_value.property.id, @property_value), :notice => "Значение #{@property_value.value} объединено со свойством #{value_names.join(', ')}. #{total} новых записей, #{errs} повторений"     
  end

  private
  
  def find_pv
     @property_value = PropertyValue.find(params[:id])
  end
  
  def load_properties
    @properties = Property.all
  end

end
