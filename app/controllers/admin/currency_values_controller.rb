require 'open-uri'
require 'rexml/document'
class Admin::CurrencyValuesController < Admin::BaseController
  access_control do
     allow :Администратор, "Редактор каталога"
  end

 def index
    @currency_values=CurrencyValue.find(:all, :order => "dt desc")

  end
  
  def cbrf_tax
    data=""
    open("http://www.cbr.ru/scripts/XML_daily.asp") {|f|
      f.each_line {|line| data<< line }      
    }
    document = REXML::Document.new data
    @kurs=[]
    @kurs[0]= document.root.attributes["Date"]
    @kurs[1]= document.root.elements["Valute[@ID='R01235']"].elements["Value"].text
    @kurs[2]= document.root.elements["Valute[@ID='R01239']"].elements["Value"].text
  end
  
  def create
   kurs = CurrencyValue.new(params[:currency])
   if  kurs.save
    flash[:notice] = "Курс на дату #{params[:currency][:dt]} установлен!"
    redirect_to admin_currency_values_path    
  else 
    flash[:error] = "Курс на дату #{params[:currency][:dt]} не может быть установлен!"
    redirect_to :action => :index
  end  
  end
  
  def destroy
    kurs = CurrencyValue.find(params[:id])
    if kurs.destroy
      flash[:notice] = "Значение курса валюты удалено!"
      redirect_to :action => :index
    end  
  end
end
