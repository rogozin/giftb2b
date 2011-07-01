#encoding: utf-8;
class Admin::ExportDataController < Admin::BaseController
  
  def index
      
  end
    
  def export
    @products  = Product.find_all(params,"xml") 
    sup_name = Supplier.find(params[:supplier]).name if params[:supplier]      
    send_data(XmlDownload.get_xml(@products,params[:options]), :type => :xml, :filename => "export_#{sup_name}_#{Date.today}.xml")
  end
    
  def permalinks
    @products = Product.joins(:categories).where({"products.active" => true, "categories.active" => true})
    send_data( XmlDownload.get_permalinks(@products), :type => :xml, :filename => "permalinks_#{Date.today}.xml")
  end  
    
end
