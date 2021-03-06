#encoding: utf-8;
require 'spec_helper'
require 'support/truncation_cleaner'

describe XmlUpload do
  context "Spec xml upload func" do
   before(:each) do      
      ActionMailer::Base.default_url_options[:host] = "127.0.0.1:3000"
      @bw = BackgroundWorker.create({:task_name => "test_xml"})
      @product = Factory(:product)       
      File.open(File.join(Rails.root, "/app/assets/images/no_image.png")) do |f|
       #i = Image.create(:picture => f)
       @product.images.create(:picture => f)
     end
      @store =Factory(:store, :supplier => @product.supplier)
      @store2 =Factory(:store, :supplier => @product.supplier)      
      @product.store_units.create(:store_id => @store.id, :count => 1984)
      @product.store_units.create(:store_id => @store2.id, :count => 1234, :option => -1)
      @xmlfile=Tempfile.new("test_xml.xml",  :encoding => 'us-ascii') 
      @xmlfile.write  XmlDownload.get_xml([@product], {:store => true, :images => true})
      @xmlfile.close
    end

    after(:each) do
       @xmlfile.close!
    end

    it 'xmlfile should be exists' do
#      puts IO.binread(@xmlfile)
      File.should be_exists(@xmlfile.path)
    end

    it "xml file should be processed when no-products in base" do
      DatabaseCleaner.clean  
       @bw = BackgroundWorker.create({:task_name => "test_xml"})
      XmlUpload.process_file(@xmlfile.path, @bw.id, {:import_images => true, :reset_images => false, :reset_properties => false} )
      Product.should have(1).record
      Product.first.images.should have(1).record
      Product.first.attach_images.first.attachable_type.should eq "Product"      
      Product.first.store_units.should have(2).records
      Product.first.store_units.map(&:count).should include(1984)
      Product.first.store_units.map(&:option).should include(-1)      
    end
    
    it "xml file should be processed when products present in base" do
      StoreUnit.update_all("count=0")
      Product.first.store_units.map(&:count).should eq [0, 0]
      XmlUpload.process_file(@xmlfile.path, @bw.id, {:import_images => false, :reset_images => false, :reset_properties => false} )
      Product.should have(1).record
      Product.first.images.should have(1).record
      Product.first.store_units.should have(2).records
      Product.first.store_units.map(&:count).should include(1984)
      Product.first.store_units.map(&:option).should include(-1)
    end
    
    
    it 'Если имя изображения совпадает, но размеры файла отличаются, картинка закачается дважды' do
      Image.all.should have(1).record
      Image.first.update_attribute(:picture_file_size, 1000)
      XmlUpload.process_file(@xmlfile.path, @bw.id, {:import_images => true, :reset_images => false, :reset_properties => false} )
      Image.all.should have(2).records
    end
    
    it 'При добавлении новой картинки у товара должно обновится поле updated_at' do

      Image.first.update_attribute(:picture_file_size, 1000)
      Product.first.update_attribute :updated_at, Date.yesterday
      XmlUpload.process_file(@xmlfile.path, @bw.id, {:import_images => true, :reset_images => false, :reset_properties => false} )
      Product.first.updated_at.should be_today
    end
    
    
    it "should have no images  when products present in base" do
      StoreUnit.update_all("count=0")
      XmlUpload.process_file(@xmlfile.path, @bw.id, {:import_images => false, :reset_images => true, :reset_properties => false} )
      Product.should have(1).record
      Image.should have(1).record
      Product.first.images.should be_empty
    end

    
  end


  context "Проверка массовой обработки файлов в директории" do
    
    def find_bw
      BackgroundWorker.first
    end

    before(:each) do
      @product = Factory.build(:product)
      @directory ||= XmlUpload.directories[:upload]
      @supplier_name = @product.supplier.name
      Dir.mkdir(@directory) unless File.exists?(@directory)
      File.open(File.join(@directory, "#{@product.supplier.name}.xml"), "w+",  :encoding => 'us-ascii') do |file|
        file << XmlDownload.get_xml([@product], {})
      end
      @creation_time = Time.now
    end

    it 'все xml файлы должны быть обработаны' do
      XmlUpload.process_files nil
      Product.should have(1).record  
      bw=find_bw
      bw.supplier_id.should == Supplier.first.id    
      bw.current_status.should == "finish"    
      File.should be_exists(File.join(XmlUpload.directories[:finish],"#{@supplier_name}_#{@creation_time.strftime(XmlUpload.time_format)}.xml"))                  
    end
    
    it "если обработка завершилась ошибкой" do
      @product.supplier.update_attribute(:name, "xxx")
      XmlUpload.process_files nil
      bw = find_bw
      bw.current_status.should == "failed"
      bw.log_errors.should == "Поставщик не найден"
      bw.supplier_id.should == -1
      File.should be_exists(File.join(XmlUpload.directories[:failed],"#{@supplier_name}_#{@creation_time.strftime(XmlUpload.time_format)}.xml"))                  
    end
    
    it "Очистка всех директорий" do
      XmlUpload.clear_dirs
      XmlUpload.directories.each_value do |dir|
      Dir.glob("#{dir}/*.xml").should be_empty
    end
    end

  end

end
