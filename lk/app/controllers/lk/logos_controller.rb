#encoding: utf-8;
class Lk::LogosController < Lk::BaseController
    access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"
  end
  
  
  def show
    @product = LkProduct.find(params[:id])
  end
  
end
