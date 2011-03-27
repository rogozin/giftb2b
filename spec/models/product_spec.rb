require 'spec_helper'

describe Product do
  subject { Product.new}
  it { should_not be_valid}
  it { should have(1).error_on(:article)}
  it { should have(1).error_on(:supplier_id)}

  context "filtering and searching" do
    
    it "active scope should not have inactive products in result" do
      Factory(:product, :short_name => "art12345", :active => false)
      Product.active.should be_empty
    end

    it "should not have inactive product in search result" do
      Factory(:product, :short_name => "art12345", :active => false)
      Product.search("art12345").should be_empty
      Product.search_with_article("art12345").should be_empty
    end
  end
end
