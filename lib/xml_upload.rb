require 'nokogiri'
require 'open-uri'
require 'fileutils'

module XmlUpload

 class << self

  def process_files(directory)
    directory ||= File.join(Rails.root, "tmp/xmlupload")
    Dir.mkdir(directory) unless File.exists?(directory)
    Dir.foreach(directory) do |x| 
      xmlfile = File.join(directory, x)
      if File.file?(xmlfile) && File.extname(x) == ".xml"
        supplier = Supplier.where({:name => File.basename(xmlfile, ".xml"), :allow_upload => true }).first
        bw = BackgroundWorker.create({:task_name => File.basename(xmlfile), :supplier_id => supplier ? supplier.id : -1 })
        if supplier.present?
          process_file(xmlfile, bw.id)
        else   
          bw.failed("Поставщик не найден")
          FileUtils.mv(xmlfile, File.join(directory, bw.current_status, File.basename(xmlfile, ".xml"), Time.now.to_s,".xml" ))
        end
      end
    end
  end

  def process_file(path, bw_id, import_images = true, reset_images = false)
    @process_images = import_images
    @reset_images = reset_images
    @bw = BackgroundWorker.find(bw_id)    
    File.open(path, 'r') do |io|      
      process_stream(io)
    end
  end
  
  def process_stream(io)
    Category.disable_cache
    @log_categories = 0
    @log_manufacors = 0
    @log_suppliers = 0
    @log_new_products = 0
    @log_upd_products = 0
    @log_current = 0
    @log_download_images =0
    @log_total_images = 0
    @log_new_properties = 0
    @log_new_property_values = 0
    @log_errors=[]     
    reader = Nokogiri::XML(io)
    @log_total  = reader.root.xpath('//item').size
    @bw.update_attributes({:total_items => @log_total, :current_status => "working"})
    @log_exec_time = Benchmark.ms do
      reader.root.xpath('//item').each do |node_set|          
          begin
            processing_xml_item( node_set.children.select{|child_nodes| child_nodes.element? })     
            rescue => error
              @log_errors<< "processing error #{error} "            
          end
          @log_current +=1
          @bw.update_attribute(:current_item, @log_current)
          @bw.update_attributes({:current_item => @log_current, :log_errors => @log_errors.reverse.join('<br />') } )
          @bw.reload
          if @bw.current_status == "stoping"
            @bw.update_attributes( {:current_status => "stop", :task_end => Time.now})
            Category.enable_cache  
            return
          end
      end  
    end
    Category.enable_cache   
    @bw.update_attributes( {:current_status => "finish", :task_end => Time.now})    
    #prepare_log_data    
    rescue => err
    puts "################## main function error #{err}"
  end
  
     
  def  upload_file(url)
    io = open(URI.parse(url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
    @log_download_images +=1 if io
    io
  end

  
  def processing_xml_item(node_set)
    manufactor_id=supplier_id=-1
    category_ids=[]
    node_set.each do |ns_item|
      manufactor_id=processing_manufactor(ns_item.content.blank? ?  "no_name" : ns_item.content) if ns_item.name=="brand_name"
      supplier_id= processing_supplier(ns_item.content)  if ns_item.name=="manufacturer_name"      
      if ns_item.name=="category_path"      
        arr=ns_item.content.split('|')
        arr.each do |cat_path|
          category_ids<<  processing_categories_chain(cat_path.split('/'))
        end
      end
    end
     import_product(manufactor_id, supplier_id, category_ids,node_set) if manufactor_id>0
     rescue => error
     @log_error<< "processing_xml_item error: #{error}"
  end
  
  def import_product(manufactor, supplier, categories, xml_nodes)    
    node= xml_nodes.find{|i| i.name==XmlSettings.fields_hash[:article]}
    return -1 unless node or node.content
    puts "=======import_product  #{node.content}"
    p=Product.find_or_initialize_by_supplier_id_and_article(supplier, node.content)  if node and supplier>0
    p.new_record? ? @log_new_products +=1 : @log_upd_products +=1
    p.category_ids= categories if categories.present?
    p.manufactor_id= manufactor if manufactor.present?
    inverted_fields = XmlSettings.fields_hash.invert
    for node in xml_nodes do
      if inverted_fields[node.name]
        p[inverted_fields[node.name]]=node.content
      end
    end
    p.save
    p.images.clear if @reset_images    
    process_image_nodes(p, xml_nodes) if @process_images
    additional_props_nodes = xml_nodes.find { |i| i.name == "additional_properties"}
    if additional_props_nodes
    additional_props_nodes.children.select{|prop_item| prop_item.name == "property"}.select{|i| i.element?}.each do |property_branch|
         property_name = property_branch.children.find{|i| i.name == "name" and i.element?}.content
         property_type = property_branch.children.find{|i| i.name == "type" and i.element?}.content.to_i
         property = find_property(p, property_name,property_type) if property_name and property_type
        if  property and property.is_a? Property
            property_branch.children.find{ |i| i.name=="values" and  i.element?}.children.select{|k| k.name == "value"}.each do |pvalue|
            find_property_value(p,property,pvalue.content) 
          end
        end
      end
    end      
  end
  
  def find_property(product, name, type=0)
    p=Property.find_or_initialize_by_name_and_property_type(name,type)
    @log_new_properties += 1 if p.new_record?
    p.save
    p.category_ids += product.category_ids
    p    
  end
  
  def find_property_value(product,property,text_value)
    pv = property.property_values.find_or_initialize_by_value(text_value)
    @log_new_property_values += 1 if pv.new_record?
    pv.save
    product.property_values<< pv unless product.property_values.include?(pv)
    rescue => error
      @log_errors<< "find_property_error: #{error}"
  end

  
  def process_image_nodes(product,xml_nodes)
    image_nodes=xml_nodes.find{ |i| i.name=="product_full_image"}
    for node in image_nodes.children do
      if node.element?
       # TODO: В дальнейшем нужно использовать URI.parse, URI.absolute?, URI.relative?
       url =  node.content.index('http://') ? node.content : "http://81.176.236.100#{ node.content }"
       @log_total_images +=1 if upload_image(product, url)
      end
    end  
    rescue => error
      @log_errors<< "process_image_nodes_error: #{error}"     
  end
  
  def upload_image(product, url)
    filename = url.split('/').last 
    img = Image.find_or_initialize_by_picture_file_name(filename)
    img.picture= upload_file(url) if img.new_record?
    product.images<< img unless product.images.include?(img)
    img.save
   rescue => img_error
   @log_errors<< "image_error for article #{product.article}, url=#{url} :#{img_error}"    
  end
  
  def processing_categories_chain(categories_chain)
    return [] if categories_chain.blank?
    Category.disable_cache
    prior_cat = nil
    cat_kind = 1
    if categories_chain.first.to_i >0
      cat_kind =  categories_chain.first.to_i
      categories_chain.delete_at(0)
    end
    #@categories ||= Category.all
     categories_chain.each_with_index do |cat_name,index|
        if index == 0
          cat = Category.find_by_name_and_kind_and_parent_id(cat_name,cat_kind,nil)
        else
          cat = Category.find_by_name_and_kind_and_parent_id(cat_name,cat_kind,prior_cat.id)
        end
        #cat = @categories.find{ |i| i.name==cat_name and i.kind==cat_kind and (index==0 ? i.parent_id ==nil : i.parent_id==prior_cat.id )  }
        if cat.blank?
         cat= (index==0 ?  Category.create({:name=>cat_name, :kind=>cat_kind}) : Category.create({:name=>cat_name, :kind=>cat_kind, :parent_id => prior_cat.id}))            
         #@categories<< cat  
         @log_categories +=1
        end
        prior_cat = cat
     end
     prior_cat.id
     rescue => error
      @log_errors<< "processing_categories_chain_error: #{error}"
  end
  
  def processing_manufactor(manufactor_name)
    return -1 if manufactor_name.blank?
    #item = @manufactors.find{|i| i.name==manufactor_name }
    item = Manufactor.find_or_initialize_by_name(manufactor_name)
    if item.new_record?
      @log_manufacors +=1
      item.save
    end
    item.id
  end
  
  def processing_supplier(supplier_name="")
    return -1 if supplier_name.blank?
    #@suppliers ||= Supplier.all  
    #item = @suppliers.find{|i| i.name==supplier_name }
    item = Supplier.find_or_initialize_by_name(supplier_name)
    if item.new_record?
      @log_suppliers +=1
      item.save
    end
    item.id
  end
 
 def prepare_log_data
    html=""
    html += "<hr />"    
    html += "<h2>Результаты обработки XML-файла:</h2>"
    html += "Всего обработано элементов : #{ @log_total_xml_items } <br />"
    html += "Добавлено новых товаров: #{@log_new_products } <br />"
    html += "Обновлено товаров: #{@log_upd_products } <br />"
    html += "Добавлено новых категорий: #{@log_categories } <br />"
    html += "Добавлено новых производителей: #{@log_manufacors } <br />"
    html += "Добавлено новых поставщиков: #{@log_suppliers } <br />"
    html += "Загружено новых изображений: #{@log_download_images } <br />"
    html += "Всего обработано ссылок на изображения: #{@log_total_images } <br />"
    html += "Создано новых свойств: #{@log_new_properties } <br />"
    html += "Создано новых значений для свойств: #{@log_new_property_values} <br />"
    html += "Затрачено времени на обработку, мс: #{@log_exec_time.to_i } <br />"    
    html += "<hr />"
    html += "Ошибки: #{@log_errors.join(', ')}" unless @log_errors.blank?
    return html
  end
  
  def calc_progress
    puts "==========update attr, #{@log_current}"    
    #@bw.update_attribute :current_item, @log_current
    bw= BackgroundWorker.find(@bw.id)
    bw.update_attribute :current_item, @log_current
  end
  
 end
end
