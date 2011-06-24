#encoding: utf-8;
class FirmsController < ApplicationController

  def index
    @firms = Firm.default_city
  end
  
  def city    
    @firms = Firm.clients.where("upper(city) = upper(:city)", {:city => params[:id]})
  end
  
  def select_town
    @towns = Firm.select("distinct city")
  end

end


