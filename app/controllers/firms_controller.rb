#encoding: utf-8;
class FirmsController < ApplicationController

  def index
    @firms = Firm.where_city_present
  end
  
  def city    
    @firms = Firm.clients.where("upper(city) = upper(:city)", {:city => params[:id]})
  end
  
  def select_town
    @towns = Firm.select("distinct city")
  end

end


