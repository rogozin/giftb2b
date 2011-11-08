#encoding: utf-8;
class Admin::BannersController < Admin::BaseController
  access_control do
     allow :Администратор
  end
  
  before_filter :find_banner, :only => [:edit, :update, :destroy]
  before_filter :find_firms, :only => [:edit, :update, :new, :create]
  
  def index
    @banners = Banner.order("updated_at desc")
  end
  
  def new
    @banner = Banner.new
  end
  
  def create
    @banner = Banner.new(params[:banner])
    if @banner.save
      redirect_to edit_admin_banner_path(@banner), :notice => "Баннер успешно создан"
    else
      render 'new'
    end
  end
  
  def edit
    
  end
  
  def update
    if @banner.update_attributes(params[:banner])
      redirect_to edit_admin_banner_path(@banner), :notice => "Баннер изменен"
    else
      render 'edit'
    end
  end
  
  def destroy
    flash[:notice] = "Баннер удален" if @banner.destroy
    redirect_to admin_banners_path
  end
  
  private 
  
  def find_banner
    @banner = Banner.find(params[:id])
  end

  def find_firms
    @firms = Firm.order(:short_name)
  end  
end

