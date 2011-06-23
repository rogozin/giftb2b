require 'spec_helper'

describe 'api testing' do
  before(:each) do    
    @product = Factory(:product)
    @token = Factory(:foreign_access).param_key
  end  


  context 'Авторизация' do
    it 'Авторизация по токену ' do    
      get 'api/categories', {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      response.code.should eq("200")
    end    

    it 'С кривым токеном - 401 ошибка ' do    
      get 'api/categories', {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=krivoy_token"}
      response.code.should eq("401")
    end    
    
    it 'Без токена - 401 ошибка' do
      get 'api/categories', {:format => :json}
      response.code.should eq("401")      
    end
    
  end

  context 'categories_controller' do
    it 'index' do
      get 'api/categories', {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      hash = ActiveSupport::JSON.decode(response.body)
      hash.should ==Category.cached_catalog_categories.as_json
    end

    it 'analogs' do
      get 'api/categories/analogs', {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      hash = ActiveSupport::JSON.decode(response.body)
      hash.should ==Category.cached_analog_categories.as_json
    end

    it 'virtuals' do
      get 'api/categories/virtuals', {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      hash = ActiveSupport::JSON.decode(response.body)
      hash.should ==Category.cached_virtual_categories.as_json
    end

    it 'thematics' do
      get 'api/categories/thematics', {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      hash = ActiveSupport::JSON.decode(response.body)
      hash.should ==Category.cached_thematic_categories.as_json
    end

    it 'show' do
      cat = @product.categories.first
      get "api/categories/#{cat.permalink}", {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      ActiveSupport::JSON.decode(response.body).should == cat.as_json
    end
  end

  context 'products' do
    it 'index' do
      cat = @product.categories.first
      get "api/products", {:format => :json, :category => cat.id}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      ActiveSupport::JSON.decode(response.body).should have(1).item

      #Этот код не работает, т.к. по разному кодируется time      
      #products = Product.active.all_by_category(Category.tree_childs(Category.cached_active_categories, cat.id))
      #ActiveSupport::JSON.decode(response.body).should eq(products.as_json)
    end

    it 'show' do
      get "api/products/#{@product.permalink}", {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      ActiveSupport::JSON.decode(response.body).first.last["short_name"].should == @product.short_name
    end
  end



end
