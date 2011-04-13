require 'spec_helper'

describe XmlUpload do
  context "Spec xml upload func" do
   before(:each) do
      @product = Factory.build(:product) 
      @xmlfile=Tempfile.new("test_xml.xml") 
      @xmlfile <<  XmlDownload.get_xml([@product], {})
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

  context "test mass xml upload from folder" do
<<<<<<< HEAD
    
    def find_bw
      BackgroundWorker.first
    end

    before(:each) do
      @product = Factory.build(:product)
      @directory ||= File.join(Rails.root, "tmp/xmlupload")
      Dir.mkdir(@directory) unless File.exists?(@directory)
      File.open(File.join(@directory, "#{@product.supplier.name}.xml"), "w+") do |file|
=======
    before(:each) do
      @product = Factory.build(:product)
      @directory ||= File.join(Rails.root, "tmp/xmlupload")
      Dir.mkdir(directory) unless File.exists?(directory)
      File.open(File.join(directory, "#{@product.supplier.name}.xml"), "w+") do |file|
>>>>>>> 1fa700bb41f8fe77dcaa6019f44b230c43ce5684
        file << XmlDownload.get_xml([@product], {})
      end
    end

    it 'xml files should be processed from tmp/xmlupload folder' do
      XmlUpload.process_files nil
      Product.should have(1).record  
<<<<<<< HEAD
      bw=find_bw
      bw.supplier_id.should == Supplier.first.id    
      bw.current_status.should == "finish"    
=======
      BackgroundWorker.first.supplier_id.should == Supplier.first.id    
      BackgroundWorker.first.current_status.should == "finish"    
>>>>>>> 1fa700bb41f8fe77dcaa6019f44b230c43ce5684
    end
    
    it "Action if supplier not found" do
      @product.supplier.update_attribute(:name, "xxx")
      XmlUpload.process_files nil
<<<<<<< HEAD
      bw = find_bw
      bw.current_status.should == "failed"
      bw.log_errors.should == "Поставщик не найден"
      bw.supplier_id.should == -1
      File.should be_exists(File.join(@directory,"failed","#{@product.supplier.name}_#{Time.now.to_s}.xml"))                  
=======
      bw = BackgroundWorker.first
      bw.current_status.should == "failed"
      bw.log_errors.should == "Поставщик не найден"
      bw.supplier_id.should == -1
                        
>>>>>>> 1fa700bb41f8fe77dcaa6019f44b230c43ce5684
    end
    it "move file into ok folder when success"
  end

end
