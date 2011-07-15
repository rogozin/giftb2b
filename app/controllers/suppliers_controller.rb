#encoding: utf-8;
class SuppliersController < ApplicationController
  access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"
  end
  
  def show
    @supplier = Supplier.find(params[:id])
  end

end
