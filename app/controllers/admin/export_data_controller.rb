class Admin::ExportDataController < Admin::BaseController
  
    def index
      
    end
    
    def export
          @products  = Product.find_all(params,"xml") 
          render :xml => XmlDownload.get_xml(@products,params[:options])

    end
end
