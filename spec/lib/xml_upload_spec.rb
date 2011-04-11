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

    it 'xml files should be processed from tmp/xmlupload folder' do
      @product = Factory.build(:product)
      File.open(File.join(Rails.root, "tmp/xmlupload/#{@product.supplier.name}.xml"), "w+") do |file|
        file << XmlDownload.get_xml([@product], {})
      end
      XmlUpload.process_files nil
      Product.should have(1).record  
      BackgroundWorker.first.supplier_id.should == Supplier.first.id    
    end
    
    it "Action if supplier not found" 
    it "move file into ok folder when success"
    it "who i will do if fail"
  end

end
