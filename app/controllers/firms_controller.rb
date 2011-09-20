#encoding: utf-8;
class FirmsController < ApplicationController

  def index
    @firms = Firm.where("length(city) > 0").order("city")
  end
  
  def city    
    @firms = Firm.clients.where("upper(city) = upper(:city)", {:city => params[:id]})
  end
  
  def select_town
    @towns = Firm.select("distinct city")
  end

end


