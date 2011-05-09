class Admin::ContentController < ApplicationController
  def index
    @content = Content.all.order("created_at desc")
  end

  def new
    @content = Content.new
    content_category
  end

  def create
    @content = Content.new(params[:admin_content])
    if @content.save
      flash[:notice] = "Страница создана"
      redirect_to edit_admin_content_path(@content)
    else
      content_category
      render  :new
    end
  end

  def edit
    @content = Content.find(params[:id])
    content_category
  end

  def update
    @content = Content.find(params[:id])
    if @content.update_attributes(params[:admin_content])
      flash[:notice] = "Страница изменена"  
      redirect_to edit_admin_content_path(@content)
    else
      content_category
      render 'edit'
    end
  end

  private
  def content_category
    @content_categories = ContentCategory.all
  end

end
