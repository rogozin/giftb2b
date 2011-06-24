#encoding: utf-8;
require 'spec_helper'

describe XmlUpload do
  context "Spec xml upload func" do
   before(:each) do
      @product = Factory.build(:product) 
      @xmlfile=Tempfile.new("test_xml.xml",  :encoding => 'us-ascii') 
      @xmlfile.write  XmlDownload.get_xml([@product], {})
      @xmlfile.close
    end

    after(:each) do
       @xmlfile.close!
    end

    it 'xmlfile should be exists' do
      File.should be_exists(@xmlfile.path)
    end

    it "xml file should be processed" do
      @bw = BackgroundWorker.create({:task_name => "test_xml"})
      XmlUpload.process_file(@xmlfile.path, @bw.id, false, false )
      Product.should have(1).record
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
