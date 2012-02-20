#encoding: utf-8;
class ContentController < ApplicationController

  def show
    @content = Content.active.find_by_permalink(params[:id])
    fresh_when(:etag => @content, :last_modified => @content.updated_at, :public => true) unless current_user           
  end

end
