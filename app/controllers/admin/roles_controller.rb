#encoding:utf-8;
class Admin::RolesController < Admin::BaseController
  access_control do
    allow :admin  
  end

  
  def index 
    @roles =  Role.all
  end
    
  def new
    @role = Role.new
  end
  
  def create
    @role = Role.new(params[:role])
    if @role.save
      redirect_to edit_admin_role_path(@role), :notice => "Роль создана"
    else 
      render :new
    end
  end

  def edit
    @role = Role.find(params[:id])
  end
  
  def update 
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      redirect_to edit_admin_role_path(@role)
    else
      render :edit
    end
  end

  def destroy
    @role= Role.find(params[:id])
    @role.destroy
    redirect_to admin_roles_path, :notice => "Роль удалена"
  end

  
  
end
