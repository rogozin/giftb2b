#encoding: utf-8;
require 'spec_helper'

describe User do
  
  subject { Factory(:user)}
  
  it 'simple user should not be firm_user' do
    should_not be_is_firm_user
  end
  
  it 'simple user should not be admin_user' do
    should_not be_is_admin_user
  end
 
  it 'assigned_supplier_ids' do
    s = Factory(:supplier)
    subject.role_objects << Role.create(:name => s.name, :description => s.name, :group => 5, :authorizable_id => s.id, :authorizable_type => "Supplier")
    subject.assigned_supplier_ids.should eq [s.id]
  end
  
  context 'generate username' do
    it 'from valid email' do
      u = User.new(:email => "vasya_pupkin@gmail.com")
      u.username_from_email.should eq "vasya_pupkin"    
    end  
    
    it 'when given email exist' do
      Factory(:user, :username => "vasya_pupkin")
      u = User.new(:email => "vasya_pupkin@gmail.com")
      u.username_from_email.should eq "vasya_pupkin_1"      
    end
    
    it 'when email is short' do
      u = User.new(:email => "v@gmail.com")      
      u.username_from_email.should eq "vab"
    end    
  end
    
  context 'create next username' do      
    it 'with optimal conditions it should be like f1.1' do
      User.next_username(1).should eq "f1.1"
    end
    
    it 'next username shoud be firm_id + 1' do
      Factory(:user, :firm_id => 234, :username => "f234.1")        
      User.next_username(234).should eq "f234.2"        
    end    
  end  
end
