#encoding: utf-8;
require 'spec_helper'

describe User do
  
  subject { Factory(:user)}
  
  it "simple user should not be firm_user" do
    should_not be_is_firm_user
  end
  
  it "simple user should not be admin_user" do
    should_not be_is_admin_user
  end
  
end
