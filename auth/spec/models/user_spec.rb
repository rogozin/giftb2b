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
  
  
  it 'update cache_key' do
    u = Factory(:user, :updated_at => 5.seconds.ago)
    cc = u.cache_key
    u.update_attributes :role_object_ids =>  [1]
    u.cache_key.should_not eq cc
  end
  
  it 'method is?(role_name)' do
    r = Role.create(:name => "test")
    u = Factory(:user, :role_objects => [r], :updated_at => 5.seconds.ago)
    u.is?(:test).should be_true   
    u.update_attributes({:role_object_ids => []}, :as => :admin)
    u.is?(:test).should be_false
    
  end
  
  it 'assigned_supplier_ids' do
    u = Factory(:user)
    s = Factory(:supplier)
    u.role_objects << Role.create(:name => s.name, :description => s.name, :group => 5, :authorizable_id => s.id, :authorizable_type => "Supplier")
    u.assigned_supplier_ids.should eq [s.id]
  end
  
end
