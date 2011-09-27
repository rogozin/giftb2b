#encoding: utf-8;
require 'spec_helper'

describe 'api testing' do
  before(:each) do    
    @product = Factory(:product)
    @firm = Factory(:firm)
    @foreign_access = Factory(:foreign_access, :firm => @firm)    
    @token = @foreign_access.param_key
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
      hash.should.as_json ==Category.cached_catalog_categories.as_json
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
    
    it 'если запросить неправильную категорию' do
      get "api/categories/not-existed", {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      response.code.should eq "404"
    end
  end


  context 'products' do
    it 'index' do
      cat = @product.categories.first
      category = Factory(:category, :parent => cat)
      @product.categories << category
      get "api/products", {:format => :json, :category => cat.id}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      ActiveSupport::JSON.decode(response.body).should have(1).item

      #Этот код не работает, т.к. по разному кодируется time      
      #products = Product.active.all_by_category(Category.tree_childs(Category.cached_active_categories, cat.id))
      #ActiveSupport::JSON.decode(response.body).should eq(products.as_json)
    end
    
    it 'если запрашиваем товары несуществующей категории' do
     get "api/products", {:format => :json, :category => 9999}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
     response.code.should eq "404"
    end

    it 'если есть категория но нет товаров' do
     category = Factory(:category)
     get "api/products", {:format => :json, :category => category.id}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
     response.code.should eq "404"
    end
    
    it 'товар пользователя подмешивается в выдачу' do
      cat = @product.categories.first
      @lk_product = Factory(:lk_product, :firm => @firm, :category_ids => [cat.id], :show_on_site => true, :active => true)
      get "api/products", {:format => :json, :category => cat.id}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      ActiveSupport::JSON.decode(response.body).should have(2).item  
    end

    it 'наличие на складе у товара' do
      @product.store_units.create(:store => Factory(:store, :supplier_id => @product.supplier.id), :count =>  123)
      get "api/products/#{@product.permalink}", {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      ActiveSupport::JSON.decode(response.body).first.last["store_count"].should eq 123
    end
    
    
    
    it 'Запрашиваем несуществующий товар' do
      get "api/products/not-exist", {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      response.code.should eq "404"      
    end

  end
  
  context 'order' do
    it 'создание новго заказа' do
      post 'api/orders', {:order => {:email => "demo@demo.ru", :phone => "888-999-32", :name => "ilya", :comment => "Комментарий", :products => [:product => {:id => @product.id, :quantity => 1, :price => @product.price_in_rub }]}}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      response.code.should eq("200")
      order = LkOrder.first
      ActionMailer::Base.deliveries.should have(2).items
      ActionMailer::Base.deliveries.map(&:to).flatten.should include("demo@demo.ru")
      ActionMailer::Base.deliveries.map(&:to).flatten.should include(order.firm.email)
      order.lk_order_items.should have(1).item
      order.is_remote.should be_true      
    end
  end

  context 'search' do
    it 'search by code' do
      get "api/search", {:q => @product.short_name, :format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      ActiveSupport::JSON.decode(response.body).should have(1).item
      response.code.should eq("200")
    end

    it 'search by name' do
      get "api/search", {:q => @product.short_name, :format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      ActiveSupport::JSON.decode(response.body).should have(1).item
      response.code.should eq("200")
    end    
  end

end
