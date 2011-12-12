#encoding:utf-8;
require 'spec_helper'

class ZeroDefender < Defender
  def clear(request)
    set_default_value cache_key(request)
  end

end

describe 'defender' do
  before(:each) do
    @product = Factory(:product)
    dir = File.join(Rails.root, "log/defender/")
    Dir.mkdir(dir) unless File.exists?(dir)    
    get "/"
    zero_defender = ZeroDefender.new(Rails.application)
    zero_defender.clear request    
  end
  

  it '100 запросов для человека' do    
    (100-1).times do |n|
      get "/products/#{@product.permalink}"
      response.code.should eq 403 if n== (100-1)
    end
  end
  
  context 'api' do
    before(:each) do
      @firm = Factory(:firm)
      @foreign_access = Factory(:foreign_access, :firm => @firm)    
      @token = @foreign_access.param_key
    end
  
    it '120 запросов для api' do    
      (120-1).times do |n|
        get "api/products/#{@product.permalink}", { :format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
        response.code.should eq 403 if n==(120-1)
      end
    end
  end
  
    
end
  
  
