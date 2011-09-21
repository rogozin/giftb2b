#encoding: utf-8;
require 'spec_helper'

describe Firm do

  it 'permalink' do
    f = Firm.new(:name => "test", :short_name => "test1")
    f.should be_valid
    f.permalink.should eq("test1")
  end
  
  it 'lat & long values' do
    f = Firm.new(:name => "test")
    f.lat = -90
    f.long = -180
    f.should be_valid
    f.lat = -100
    f.long = -300
    f.should_not be_valid
    f.lat = 91
    f.long = 181    
    f.should_not be_valid
  end
  
end
