require 'test_helper'
require 'xml_upload'

class XmlUploadTest < ActiveSupport::TestCase

  def setup      
  end
      
  def teardown
  end


  test "Checking import" do
    bw=BackgroundWorker.create({:task_name => "test"})    
    res=XmlUpload.process_file(File.expand_path(File.dirname(__FILE__)) + "/xml_test.xml", bw.id, false)      
    puts "=========#{Product.all.size}"
    assert_equal Product.all.size, 3
    assert_equal Category.all.size, 8    
    assert_equal Property.all.size, 2    
    assert_equal PropertyValue.all.size, 4
    assert_equal Image.all.size, 0
  end    

  
  test "Check images in double import" do
    bw=BackgroundWorker.create({:task_name => "test_db_img"})    
    res=XmlUpload.process_file(File.expand_path(File.dirname(__FILE__)) + "/xml_test.xml", bw.id, false)      
    assert_equal Image.all.size, 0
    assert_equal Product.find_by_article('Z38102').images.size, 0    

    res=XmlUpload.process_file(File.expand_path(File.dirname(__FILE__)) + "/xml_test.xml", bw.id, true)          
    #assert_equal Image.all.size, 4
    assert_equal Product.find_by_article('Z38102').images.size, 3
    
  end 
  
  
end
