class Admin::ContentsController < Admin::BaseController
  uses_tiny_mce(:options => AppConfig.default_mce_options, :only => [:new, :edit])
  access_control do
     allow :Администратор, "Редактор контента"
  end
    

  def index
    @content = Content.order("created_at desc")
  end

  def new
    @content = Content.new
    content_category
  end

  def create
    @content = Content.new(params[:content])
    if @content.save
      flash[:notice] = "Страница создана"
      redirect_to edit_admin_content_path(@content)
    else
      content_category
      render  :new
    end
  end

  def edit
    @content = Content.find_by_permalink(params[:id])
    content_category
  end

  def update
    @content = Content.find_by_permalink(params[:id])
    if @content.update_attributes(params[:content])
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
