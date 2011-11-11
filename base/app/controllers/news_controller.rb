class NewsController < ApplicationController
  def index
    params[:page] ||= 1
    @news = News.active.paginate(:page => params[:page])
  end

  def show
    @news = News.find_by_permalink(params[:id])
  end

end
