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
  
  it 'generate username from email' do
    u = User.new(:email => "vasya_pupkin@gmail.com")
    u.username_from_email.should eq "vasya_pupkin"    
    Factory(:user, :username => "vasya_pupkin")
    u = User.new(:email => "vasya_pupkin@gmail.com")
    u.username_from_email.should eq "vasya_pupkin_1"
    u = User.new(:email => "v@gmail.com")      
    u.username_from_email.should eq "vab"
  end
  
  it 'next_username' do
    User.next_username(1).should eq "f1.1"
    Factory(:user, :firm_id => 234, :username => "f234.1")
    User.next_username(234).should eq "f234.2"
    Factory(:user, :firm_id => 234, :username => "super_admin")
    User.next_username(234).should eq "f234.2"
  end
  
end
