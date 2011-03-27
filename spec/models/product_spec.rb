require 'spec_helper'

describe Product do
  subject { Product.new}
  it { should_not be_valid}
  #it { should have.error_on(:article)}
  #it { should have.error_on(:supplier_id)}
end
