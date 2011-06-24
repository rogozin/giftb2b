#encoding: utf-8;
class Admin::ManufactorsController < Admin::BaseController
  access_control do
     allow :Администратор, "Редактор каталога"
  end
  
  def index
    @manufactors_list = Manufactor.all
  end

  def create
     @manufactor = Manufactor.create(:name=>params[:name])
  end

  def edit
    @manufactor= Manufactor.find(params[:id])    
  end

  def update
    @manufactor = Manufactor.find(params[:id])
    if @manufactor.update_attributes  params[:manufactor]
      flash[:notice] = "Производитель изменен"
      redirect_to admin_manufactors_path
    else 
      render 'edit'  
    end
  end

def destroy
    @manufactor = Manufactor.find(params[:id])
    flash[:notice] = "Производитель удален" if    @manufactor.destroy
    redirect_to admin_manufactors_path
  end
end  
