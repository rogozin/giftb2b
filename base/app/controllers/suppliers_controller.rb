#encoding: utf-8;
class SuppliersController < ApplicationController
  access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"
  end
  
  def show
    @supplier = Supplier.find_by_permalink(params[:id])
  end

end
