class ContentCategoryController < ApplicationController

  def show
    @content_category = ContentCategory.find_by_permalink(params[:id])
    @pages = @content_category.active_pages.paginate(:page => params[:page]||"1", :per_page => 10)
  end

end
