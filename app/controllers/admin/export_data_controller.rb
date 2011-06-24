#encoding: utf-8;
class Admin::ExportDataController < Admin::BaseController
  
  def index
      
  end
    
  def export
    @products  = Product.find_all(params,"xml") 
    render :xml => XmlDownload.get_xml(@products,params[:options])
  end
    
  def permalinks
    @products = Product.joins(:categories).where({"products.active" => true, "categories.active" => true})
    send_data( XmlDownload.get_permalinks(@products), :type => :xml, :filename => "permalinks_#{Date.today}.xml")
  end  
    
end
