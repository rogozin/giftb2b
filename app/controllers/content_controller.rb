class ContentController < ApplicationController
  def show
    @content = Content.find_by_permalink(params[:id])
  end

end
