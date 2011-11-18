#encoding: utf-8;
class Lk::SamplesController < Lk::BaseController
  before_filter :find_sample, :only => [:edit, :update, :destroy]
  before_filter :prepare_collections, :only => [:index,:new,:edit, :create, :update]
  helper_method :can_edit_sample?
  access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"
  end
  
  def index
    params[:page] ||=1
    #если мы исппользуем фильтр и чекбокс "hide_closed" не выбран:
    params[:hide_closed] ="0"  if params[:hide_closed].blank? && params.has_key?(:name)
    params[:only_my] ="0"  if params[:only_my].blank? && params.has_key?(:name)
    @samples = Sample.scoped
    @samples = @samples.where(:firm_id => current_user.firm_id || -1)
    @samples = @samples.where(:supplier_id => params[:supplier]) if params[:supplier].present?
    @samples = @samples.where(:lk_firm_id => params[:client]) if params[:client].present?
    @samples = @samples.where(:responsible_id => params[:responsible]) if params[:responsible].present?    
    @samples = @samples.where(:closed => false) if params[:hide_closed].blank? ||  params[:hide_closed] == "1"
    @samples = @samples.where("user_id = :user_id or responsible_id = :user_id", :user_id => current_user.id) if params[:only_my].blank? ||  params[:only_my] == "1"
    @samples = @samples.where("name like :name", :name  => "%"+params[:name]+"%") if params[:name].present?    
    @samples = @samples.order("id desc").paginate(:page => params[:page])
  end

  def new
    @sample = Sample.new(:user => @current_user)
  end
  
  def create
    @sample = Sample.new(params[:sample])
    @sample.firm_id = current_user.firm_id
    if @sample.save
      flash[:notice] = "Образец создан."
      redirect_to edit_sample_path(@sample)
    else
      render :new
    end
  end

  def edit

  end
  
  def update
    if @sample.update_attributes( params[:sample] )
      flash[:notice] = "Образец изменен!"
      redirect_to edit_sample_path(@sample)
    else
      render :edit
    end    
  end

  def destroy
    flash[:notice] = "Образец удален!" if @sample.destroy
    redirect_to samples_path
  end

  private

  def can_edit_sample?(sample)
    !sample.closed? || (current_user.is_admin? || current_user.is_firm_manager?)
  end

  def find_sample
    @sample = Sample.where(:firm_id => current_user.firm_id).find(params[:id])
    redirect_to samples_path, :alert => "Нет доступа. Образец закрыт." unless can_edit_sample?(@sample)    
  end
  
  def prepare_collections
    @suppliers = Supplier.order(:name)
    @firms =  current_user && current_user.firm  ? LkFirm.where(:firm_id => current_user.firm.id) : []
    @responsibles = current_user.firm && current_user.firm.users.present? ? current_user.firm.users.order(:fio) : []
  end
  

end
