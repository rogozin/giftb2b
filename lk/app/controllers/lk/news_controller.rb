#encoding:utf-8;
class Lk::NewsController < Lk::BaseController
  access_control do
    allow :admin, :lk_news 
  end
    
  before_filter :check_firm
  before_filter :find_news, :only => [:edit, :update, :send_to_moderate, :remove_from_moderate, :destroy]
  before_filter :check_news_state, :only => [:edit, :update]
  
  def index
  end
  
  def drafts
    find_all_news([3,4], "state_id desc, created_at desc")
  end
  
  def moderate
    find_all_news([0])
  end
  
  def published
   find_all_news([1])
  end
  
  def archived
   find_all_news([2])
  end

  
  def new
    @news =  News.new
  end
  
  def create
    @news = News.new(params[:news])
    @news.firm_id = current_user.firm_id
    @news.created_by = current_user.id
    @news.state_id = 3
    if @news.save
      if params[:moderate].present?
        @news.update_attribute :state_id, 0 
        redirect_to moderate_news_index_path, :notice => "Новость создана и отправлена на модерацию"
      else
        redirect_to drafts_news_index_path, :notice => "Новость создана. Для дальнейшей публикации на сайте giftb2b.ru отправьте ее на модерацию."
      end
    else
      render 'new'
    end
  end
  
  def edit

  end
  
  def update
    @news.state_id = 0 if params[:moderate].present?
    if @news.update_attributes(params[:news])      
      if params[:moderate].present?
        redirect_to moderate_news_index_path, :notice => "Новость сохранена и отправлена на модерацию"
      else 
        redirect_to drafts_news_index_path, :notice => "Новость сохранена"
      end
    else
      render 'edit'
    end
  end

  def send_to_moderate
    flash[:notice] = "Новость отправлена на модерацию!" if @news.update_attribute :state_id, 0
    redirect_to drafts_news_index_path
  end
  
  def remove_from_moderate
     return redirect_to news_index_path, :alert => "Новость уже опубликована!" if @news.state_id != 0
    flash[:notice] = "Новость снята с модерации!" if @news.update_attribute :state_id, 3
    redirect_to moderate_news_index_path          
  end
  
  def destroy
    flash[:notice] = "Новость удалена" if @news.destroy
    redirect_to drafts_news_index_path
  end
  
  private 
  
  def find_all_news(state_id, sort_string="created_at desc")
    params[:page] ||=1
    @news = News.where(:firm_id => current_user.firm_id, :state_id => state_id).order(sort_string).paginate(:page => params[:per_page])        
  end
  
  def find_news
    @news = News.where(:firm_id => current_user.firm_id).find_by_permalink(params[:id])
    raise ActiveRecord::RecordNotFound unless @news
  end
  
  def check_news_state
    return redirect_to news_index_path, :alert => "Редактировать можно только черновик!" unless @news.draft?
  end

  
end
