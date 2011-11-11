#encoding: utf-8;
class Admin::NewsController < Admin::BaseController
    access_control do
     allow :Администратор, "Редактор контента"
  end
  
  before_filter :find_collections


  def index
    @news = News.order("created_at desc")      
  end
  
  def show
    @news = News.find(params[:id])
    render 'show', :layout => "application"
  end
  
  def new
    @news = News.new(:firm_id => current_user.firm_id)
  end
  
  def edit
    @news  = News.find_by_permalink(params[:id])
  end
  
  def create
    @news = News.new(params[:news].merge(:created_by => current_user.id))
    if @news.save
      redirect_to admin_news_index_path, :notice => "Новость создана!"
    else
      render 'new'
    end
  end
  
  def update
    @news = News.find_by_permalink(params[:id])
    if @news.update_attributes(params[:news].merge(:updated_by => current_user.id))
      redirect_to admin_news_index_path, :notice => "Новость изменена"
    else
      render 'edit'
    end
  end
  
  def destroy
    @news = News.find_by_permalink(params[:id])
    flash[:notice] = "Новость удалена"  if @news.destroy
    redirect_to admin_news_index_path
  end

  private
  
  def find_collections
    
    @firms= Firm.order("name")
    @states= News.states.to_a
  end

end
