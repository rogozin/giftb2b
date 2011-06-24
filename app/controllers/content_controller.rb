#encoding: utf-8;
class ContentController < ApplicationController
  def show
    @content = Content.find_by_permalink(params[:id])
    if @content.active?
      render :show
    else
      not_found("Запрошенная страница не существует")
    end
  end

end
