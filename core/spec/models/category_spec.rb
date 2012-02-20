#encoding: utf-8;
require 'spec_helper'

describe Category do
  subject {ContentCategory.new}

  it {should have(1).errors_on(:name)}

  it 'permalink checks' do
    @category = Factory(:category)
    @category.permalink.should == @category.name.parameterize
  end
  
  it 'cached products size' do
    @category = Factory(:category)
    product_ids = []
    3.times { product_ids << Factory(:product).id }
    @category.product_ids = product_ids
    @category.products_size.should eq 3
  end
  
end
