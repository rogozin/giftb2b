class ContentCategoryController < ApplicationController

  def show
    @content_category = ContentCategory.find_by_permalink(params[:id])
  end

end
