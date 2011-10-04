require 'spec_helper'

describe StoreUnit do
  it 'validate' do
    su = StoreUnit.new(:option => 2)
    su.should_not be_valid
    su.should have(1).error_on(:product_id)
    su.should have(1).error_on(:store_id)
    su.should have(1).error_on(:option)
  end
  
end
