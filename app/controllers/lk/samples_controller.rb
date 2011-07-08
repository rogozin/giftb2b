#encoding: utf-8;
class Lk::SamplesController < Lk::BaseController
  before_filter :find_sample, :only => [:edit, :update, :destroy]
  before_filter :prepare_collections, :only => [:index,:new,:edit, :create, :update]
  
  access_control do
     allow :Администратор, "Учет образцов"
  end
  
  def index
    params[:page] ||=1
    @samples = Sample.scoped
    @samples = @samples.where(:supplier_id => params[:supplier]) if params[:supplier].present?
    @samples = @samples.where(:firm_id => params[:client]) if params[:client].present?
    @samples = @samples.where(:responsible_id => params[:responsible]) if params[:responsible].present?    
    @samples = @samples.where("name like :name", :name  => "%"+params[:name]+"%") if params[:name].present?    
    @samples = @samples.order("id desc").paginate(:page => params[:page])
  end

  def new
    @sample = Sample.new(:user => @current_user)
  end
  
  def create
    @sample = Sample.new(params[:sample])
    if @sample.save
      flash[:notice] = "Образец создан."
      redirect_to edit_lk_sample_path(@sample)
    else
      render :new
    end
  end

  def edit
    
  end
  
  def update
    if @sample.update_attributes( params[:sample] )
      flash[:notice] = "Образец изменен!"
      redirect_to edit_lk_sample_path(@sample)
    else
      render :edit
    end    
  end

  def destroy
    flash[:notice] = "Образец удален!" if @sample.destroy
    redirect_to lk_samples_path
  end
  
  private
  
  def find_sample
    @sample = Sample.find(params[:id])
  end
  
  def prepare_collections
    @suppliers = Supplier.order(:name)
    @firms =  current_user && current_user.firm  ? LkFirm.where(:firm_id => current_user.firm.id) : []
    @responsibles = current_user.firm && current_user.firm.users.present? ? current_user.firm.users : []
  end

end
