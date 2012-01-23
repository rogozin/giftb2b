#encoding:utf-8;
class Admin::ServicesController < Admin::BaseController
  access_control do
    allow :admin, :admin_users
  end
  
  before_filter :get_roles, :except => [:index, :destroy] 
  
  def index
    @services = Service.order("id desc")
  end

  def new
    @service = Service.new
  end
  
  def create
    @service = Service.new(params[:service])
    if @service.save
      redirect_to edit_admin_service_path(@service), :notice => "Услуга создана"
    else 
      render :new
    end
  end

  def edit
    @service = Service.find(params[:id])
  end
  
  def update 
    @service = Service.find(params[:id])
    if @service.update_attributes(params[:service])
      redirect_to edit_admin_service_path(@service)
    else
      render :edit
    end
  end

  def destroy
    @service= Service.find(params[:id])
    @service.destroy
    redirect_to admin_services_path, :notice => "Услуга удалена"
  end
  
  
  private 
  
  def get_roles
    @roles = Role.scoped
  end

end
