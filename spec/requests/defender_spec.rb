#encoding:utf-8;
require 'spec_helper'

class ZeroDefender < Defender
  LINKS_WHITELIST = [ /\/products\/my-white-product$/ ]
  
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
    @zero_defender = ZeroDefender.new(Rails.application)
    @zero_defender.clear request    
  end
  

  it '100 запросов для человека' do    
    (100-1).times do |n|
      get "/products/#{@product.permalink}"
      response.code.should eq 403 if n== (100-1)
    end
  end
  
  it 'неограниченно запросов если путь в белом списке' do
    @product.update_attributes :permalink => "my-white-product"
      (100).times do |n|
      get "/products/#{@product.permalink}"
      response.code.should eq 200 if n== (100)
    end
    
  end
  
 
  it 'неограничено для бота' do    
    Defender.class_eval do 
      define_method(:search_bot?){|request| true }
    end
    st = []
    (200).times do |n|
      get "/products/#{@product.permalink}"
      st << response.code
    end
    st.all?{ |x| x=="200"}.should be_true
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
  
  
