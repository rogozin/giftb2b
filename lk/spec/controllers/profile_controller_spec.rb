#encoding:utf-8;
require 'spec_helper'

describe Lk::ProfileController do

  
  before(:each) do     
    direct_login_as :user
    @user.role_objects = [Factory(:r_supplier)]
    @firm = Factory(:firm, :users => [@user])    
  end


end
