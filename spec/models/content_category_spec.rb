#encoding: utf-8;
require 'spec_helper'

describe ContentCategory do
  subject {ContentCategory.new}

  it {should have(1).errors_on(:name)}
  it 'maximum length = 255 for name and permalink' do
     name = gen_content(256)
     permalink = gen_content(256)
     should have(1).error_on(:name)
  end

  it 'permalink checks' do
    @content_category = Factory(:content_category)
    @content_category.permalink.should == @content_category.name.parameterize
    @content_category.permalink = gen_content(256)
    @content_category.should have(1).error_on(:permalink)      
  end
end
