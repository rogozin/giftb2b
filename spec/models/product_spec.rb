require 'spec_helper'

describe Product do
  before(:each) do
    CurrencyValue.create({:dt => Date.today, :usd => 30, :eur => 40})
  end
   
  subject { Product.new}
  it { should_not be_valid}
#  it { should have(1).error_on(:article)}
#  it { should have(1).error_on(:supplier_id)}

  it 'all_by_category' do
    
  end

  context "filtering and searching" do
    before do
      Factory(:product, :short_name => "art12345", :active => false)      
    end
    
    it "active scope should not have inactive products in result" do
      Product.active.should be_empty
    end

    it "should not have inactive product in search result" do
      Product.search("art12345").should be_empty
      Product.search_with_article("art12345").should be_empty
    end
  end
  
  context "sorting" do
    it "products without cost should be at the end of the list" do
      p1 = Factory(:product, :article => "B001", :price => 100, :sort_order => 10)      
      p3 = Factory(:product, :article => "A001", :supplier_id => p1.supplier_id, :price => 0, :sort_order =>20)
      c = Factory(:category, :name => "cat1")
      c.products << [p1, p3]
     search_result = Product.find_all({:page=>1, :per_page=>30, :category=> c.id})
     search_result.last.should == p3
    end
  end
  
end

