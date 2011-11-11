#encoding:utf-8;
class Lk::NewsController < Lk::BaseController
  access_control do
    allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"     
  end
  
  before_filter :find_news, :only => [:edit, :update, :send_to_moderate, :destroy]
  before_filter :check_news_state, :only => [:edit, :update]
  
  def index
      params[:page] ||=1
    if current_user.firm_id.present?
      @news = News.where(:firm_id => current_user.firm_id).order("created_at desc").paginate(:page => params[:per_page])
    else 
      @news  = []
      not_firm_assigned!
    end

  end
  
  def new
    @news =  News.new(:firm_id => current_user.firm_id, :state_id => 3)
  end
  
  def create
    @news = News.new(params[:news].merge({:firm_id => current_user.firm_id, :created_by => current_user.id, :state_id => 3}))
    if @news.save
      redirect_to news_index_path, :notice => "Новость создана. Для дальнейшей публикации на сайте giftb2b.ru отправьте ее на модерацию."
    else
      render 'new'
    end
  end
  
  def edit

  end
  
  def update
    if @news.update_attributes(params[:news])
      redirect_to news_index_path, :notice => "Новость изменена."
    else
      render 'edit'
    end
  end

  def send_to_moderate
    flash[:notice] = "Новость отправлена на модерацию!" if @news.update_attribute :state_id, 0
    redirect_to news_index_path
  end
  
  def destroy
     return redirect_to news_index_path, :alert => "Новость уже опубликована!" if @news.state_id != 0
    flash[:notice] = "Новость снята с модерации!" if @news.update_attribute :state_id, 3
    redirect_to news_index_path      
  end
  
  private 
  
  def find_news
    @news = News.where(:firm_id => current_user.firm_id).find_by_permalink(params[:id])
    raise ActiveRecord::RecordNotFound unless @news
  end
  
  def check_news_state
    return redirect_to news_index_path, :alert => "Редактировать можно только черновик!" if @news.state_id != 3
  end

  
end
