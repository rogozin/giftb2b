class Admin::ContentCategoriesController < Admin::BaseController
  access_control do
     allow :Администратор, "Редактор контента"
  end
  
  def index
    @content_categories = ContentCategory.all
  end

  def new
    @content_category = ContentCategory.new
  end
  
  def create
    @content_category = ContentCategory.new(params[:content_category])
    if @content_category.save
      flash[:notice] = "Категория создана"
      redirect_to edit_admin_content_category_path(@content_category)
    else
      render :new
    end
  end
  

  def edit
    @content_category = ContentCategory.find_by_permalink(params[:id])
  end

  def update
    @content_category = ContentCategory.find_by_permalink(params[:id])
    if @content_category.update_attributes(params[:content_category])
      flash[:notice] = "Категория изменена"
      redirect_to edit_admin_content_category_path(@content_category)
    else
      render :edit
    end
  end  
  
  def destroy
    @content_category = ContentCategory.find_by_permalink(params[:id])
    if @content_category.contents.empty?
      @content_category.destroy
      flash[:notice] = "Категория удалена"
    else
      flash[:error] = "Не могу удалить категорию. Имеются записи."
    end
    redirect_to admin_content_categories_path
  end  

end
