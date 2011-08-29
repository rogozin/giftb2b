#encoding: utf-8;
require 'spec_helper'

describe Product do
  
  subject { LkProduct.new(:price => nil)}
  it { should_not be_valid}
  it { should have(1).error_on(:price)}
end
