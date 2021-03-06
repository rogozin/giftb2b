#encoding: utf-8;
require 'nokogiri'
require 'open-uri'
require 'fileutils'

module XmlUpload

 class << self
   cattr_accessor :time_format, :directories, :base_dir
   self.time_format = "%d-%m-%Y_%H-%M"
   self.base_dir = File.join(Rails.root,"tmp/xmlupload")
   self.directories = {:upload => self.base_dir, :finish => File.join(self.base_dir,"finish"), :failed => File.join(self.base_dir,"failed")}

  def create_dirs
    self.directories.each_value do |dir|
      Dir.mkdir(dir) unless File.exists?(dir)
    end
  end  
    
  def move_file xmlfile, status
    FileUtils.mv(xmlfile, File.join(self.directories[status], [File.basename(xmlfile, ".xml"), "_", Time.now.strftime(self.time_format),".xml"].join )) 
  end
  
  def clear_dirs
    self.directories.each_value do |dir|
      FileUtils.rm_r Dir.glob("#{dir}/*.xml")
    end
  end
  
  private :create_dirs, :move_file
  
  def process_files(directory)
    create_dirs
    directory ||= self.directories[:upload]
    Dir.foreach(directory) do |x| 
      xmlfile = File.join(directory, x)
      if File.file?(xmlfile) && File.extname(x) == ".xml"
        supplier = Supplier.where({:name => File.basename(xmlfile, ".xml"), :allow_upload => true }).first
        bw = BackgroundWorker.create({:task_name => File.basename(xmlfile), :supplier_id => supplier ? supplier.id : -1 })
        if supplier.present?
          supplier.deactivate_all_products
          process_file(xmlfile, bw.id)
          move_file xmlfile, :finish
        else   
          bw.failed("Поставщик не найден")
          move_file xmlfile, :failed
        end
      end
    end
  end

  def process_file(path, bw_id, options={})
    #options[:import_images] ||= true
    options[:reset_images] ||= false
    options[:reset_properties] ||= false
    @process_images = options[:import_images]
    @reset_images = options[:reset_images]
    @reset_properties = options[:reset_properties]
    @bw = BackgroundWorker.find(bw_id)    
    File.open(path, 'r') do |io|      
      process_stream(io)
    end
  end
  
  def process_stream(io)
    Category.disable_cache
    @log_current = 0
    @log_errors=[]     
    reader = Nokogiri::XML(io)
    @log_total  = reader.root.xpath('//item').size
    @bw.update_attributes({:total_items => @log_total, :current_status => "working"})
    reader.root.xpath('//item').each do |node_set|          
        begin
          processing_xml_item( node_set.children.select{|child_nodes| child_nodes.element? })     
          rescue => error
            @log_errors<< "processing error #{error} "            
          end
        @log_current +=1
        @bw.update_attributes({:current_item => @log_current, :log_errors => @log_errors.reverse.join('<br />') } )
        @bw.reload
        if @bw.current_status == "stoping"
          @bw.update_attributes( {:current_status => "stop", :task_end => Time.now})
          Category.enable_cache  
          return
        end
    end  
    Category.enable_cache   
    Rails.cache.delete('novelty_products')
    Rails.cache.delete('sale_products')
    @bw.update_attributes( {:current_status => "finish", :task_end => Time.now})    
    #prepare_log_data    
    rescue => err
    puts "################## main function error #{err}"
  end
  
     
  def  upload_file(url)
    io = open(URI.parse(url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
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
     @log_errors << "processing_xml_item (art:#{node_set.find{|i| i.name==XmlSettings.fields_hash[:article]}}) error: #{error}"
  end
  
  def import_product(manufactor, supplier, categories, xml_nodes)    
    node= xml_nodes.find{|i| i.name==XmlSettings.fields_hash[:article]}
    return -1 unless node or node.content
    puts "=======import_product  #{node.content}"
    p=Product.find_or_initialize_by_supplier_id_and_article(supplier, node.content)  if node and supplier>0
    p.category_ids= categories if categories.present?
    p.manufactor_id= manufactor if manufactor.present?
    inverted_fields = XmlSettings.fields_hash.invert
    for node in xml_nodes do
      if inverted_fields[node.name]
        p[inverted_fields[node.name]]=node.content
      end
    end
    p.sort_order = 999 if p.price == 0 && p.sort_order < 999
    p.save
    p.images.clear if @reset_images    
    process_image_nodes(p, xml_nodes) if @process_images
    process_store(p, xml_nodes)
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
    if p.new_record?    
      p.save
    else
      #TODO - возможно вместо массива всех значений свойств нужно удалять только те, которые реально есть у товара.
      ProductProperty.delete_all(:product_id => product.id, :property_value_id => p.property_value_ids) if @reset_properties
    end
    p.category_ids += product.category_ids
    p    
  end
  
  def find_property_value(product,property,text_value)
    pv = property.property_values.find_or_initialize_by_value(text_value)
    pv.save
    product.property_values<< pv if @reset_properties || product.property_values.exclude?(pv) 
    rescue => error
      @log_errors<< "find_property_error: #{error}"
  end


  def process_store(product, nodes)
    store_element =  nodes.find{ |i| i.name=="store" && i.element?}
    if store_element
      store_element.children.select{|x| x.name =="store_item"}.each do |store_unit|      
        store_name =  store_unit.children.find{|i| i.name== "name"}.content 
        store_count =  store_unit.children.find{|i| i.name== "count"}.content 
        option =  store_unit.children.find{|i| i.name== "option"}.content 
        store = Store.find_or_create_by_name_and_supplier_id(store_name, product.supplier_id)
        product.store_units.create(:store => store, :count => store_count, :option => option)
      end
    end
  end
  
  def process_image_nodes(product,xml_nodes)
    image_nodes=xml_nodes.find{ |i| i.name=="product_full_image"}
    if image_nodes
    for node in image_nodes.children do
      if node.element?
       # TODO: В дальнейшем нужно использовать URI.parse, URI.absolute?, URI.relative?
       if node.content.start_with?("file://")
        #read_file(product,node.content.gsub("file://", ""))
       else
        url =  node.content.start_with?('http://') ? node.content : "http://#{ActionMailer::Base.default_url_options[:host]}#{ node.content }"
        upload_image(product, url)
      end
     end
    end  
    end
    rescue => error
      @log_errors<< "process_image_nodes_error: #{error}"     
  end
    
  def upload_image(product, url)
    filename = url.split('/').last 
    need_touch  = false
    new_img = upload_file(url)  
    images = Image.where(:picture_file_name => filename, :picture_file_size => new_img.size)
    img = images.present? ? images.first :  Image.create(:picture => new_img)
    if product.images.exclude?(img)
      AttachImage.create(:attachable => product, :image => img) 
      need_touch = true
    end
    product.touch if need_touch && !product.updated_at.today?
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
    categories_chain.each_with_index do |cat_name,index|
      if index == 0
        cat = Category.find_by_name_and_kind_and_parent_id(cat_name,cat_kind,nil)
      else
        cat = Category.find_by_name_and_kind_and_parent_id(cat_name,cat_kind,prior_cat.id)
      end
      if cat.blank?
        cat= (index==0 ?  Category.create({:name=>cat_name, :kind=>cat_kind}) : Category.create({:name=>cat_name, :kind=>cat_kind, :parent_id => prior_cat.id}))
      end
      prior_cat = cat
    end
      prior_cat.id
    rescue => error
      @log_errors << "processing_categories_chain_error: #{error}"
  end
  
  def processing_manufactor(manufactor_name)
    return -1 if manufactor_name.blank?
    item = Manufactor.find_or_initialize_by_name(manufactor_name)    
    item.save if item.new_record?
    item.id
  end
  
  def processing_supplier(supplier_name="")
    return -1 if supplier_name.blank?
    item = Supplier.find_or_initialize_by_name(supplier_name)
    item.save if item.new_record?
    item.id
  end
 
  
  def calc_progress
    @bw.update_attribute :current_item, @log_current
  end
  
 end
end
