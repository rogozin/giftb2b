#encoding: utf-8;
require 'spec_helper'

describe 'api testing' do
  before(:each) do    
    @product = Factory(:product, :is_new => true, :is_sale => true)
    @firm = Factory(:firm)
    @foreign_access = Factory(:foreign_access, :firm => @firm)    
    @token = @foreign_access.param_key
    ActionMailer::Base.deliveries.clear
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
      @json_object = ActiveSupport::JSON.decode(response.body).first["product"]
      @json_object.should_not have_key("colors")
      @json_object.should_not have_key("properties")
      @json_object.should_not have_key("similar")
      @json_object.should have_key("pictures")
      #Этот код не работает, т.к. по разному кодируется time      
      #products = Product.active.all_by_category(Category.tree_childs(Category.cached_active_categories, cat.id))
      #ActiveSupport::JSON.decode(response.body).should eq(products.as_json)
    end
    
    it 'show' do
      get "api/products/#{@product.permalink}", { :format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      @json_object = ActiveSupport::JSON.decode(response.body)["product"]
      @json_object.should have_key("colors")
      @json_object.should have_key("properties")
      @json_object.should have_key("similar")
      @json_object.should have_key("pictures")
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
    
    it 'товар пользователя запрашивается отдельно' do
      cat = @product.categories.first
      @lk_product = Factory(:lk_product, :firm => @firm, :category_ids => [cat.id], :show_on_site => true, :active => true)
      get "api/products/lk", {:format => :json, :category => cat.id}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      ActiveSupport::JSON.decode(response.body).should have(1).item 
    end

    it 'если не указана категория, выводятся все товары пользователяt' do
    @lk_product = Factory(:lk_product, :firm => @firm, :category_ids => [@product.categories.first.id], :show_on_site => true, :active => true)
    @lk_product = Factory(:lk_product, :firm => @firm,  :show_on_site => true, :active => true)
    get "api/products/lk", {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      ActiveSupport::JSON.decode(response.body).should have(2).items 
    end

    it 'наличие на складе у товара' do
      @product.store_units.create(:store => Factory(:store, :supplier_id => @product.supplier.id), :count =>  123)
      get "api/products/#{@product.permalink}", {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      ActiveSupport::JSON.decode(response.body)["product"]["store_count"].should eq 123
    end
    
    it 'Новинки' do
      get "api/products/novelty", {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}      
      ActiveSupport::JSON.decode(response.body).should have(1).item
    end
    
        
    it 'Распродажа' do
      get "api/products/sale", {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}      
       ActiveSupport::JSON.decode(response.body).should have(1).item
    end
    
    it 'Запрашиваем несуществующий товар' do
      get "api/products/not-exist", {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      response.code.should eq "404"      
    end
    
    it 'Запрашиваем неактивный товар' do
      @product.update_attribute :active, false
      get "api/products/#{@product.permalink}", {:format => :json}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      response.code.should eq "404"      
    end    

  end
  
  context 'order' do
    it 'создание новго заказа' do
      post 'api/orders', {:order => {:email => "demo@demo.ru", :phone => "888-999-32", :name => "ilya", :comment => "Комментарий", :products => [:product => {:id => @product.id, :quantity => 1, :price => @product.price_in_rub }]}}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
      response.code.should eq("200")
      order = LkOrder.first
      order.lk_order_items.should have(1).item
      order.is_remote.should be_true      
      ActionMailer::Base.deliveries.should have(2).items
      ActionMailer::Base.deliveries.map(&:to).flatten.should include("demo@demo.ru")
      ActionMailer::Base.deliveries.map(&:to).flatten.should include(order.firm.email)
    end
    
    context 'разные способы передачи массива в заказе' do
      before(:each) do
       @product2 = Factory(:product)
      end

# Этот способ передачи параметров не работает, на сервер передается только один элемент :product
#      it 'передача с ключом product' do        
#        expect {
#         post 'api/orders', {:order => {:email => "demo@demo.ru", :phone => "888-999-32", :name => "ilya", :comment => "Комментарий", :products => [{:product => {:id => @product.id, :quantity => 1, :price => @product.price_in_rub }}, {:product => {:id => @product2.id, :quantity => 2, :price => 111 }}]}}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
#         }.to change(LkOrder, :count).by(1) && change(LkOrderItem, :count).by(2)
#        response.code.should eq("200")
#      end
      
      it 'передача без ключа product' do        
        expect {
         post 'api/orders', {:order => {:email => "demo@demo.ru", :phone => "888-999-32", :name => "ilya", :comment => "Комментарий", :products => [{:id => @product.id, :quantity => 1, :price => @product.price_in_rub }, {:id => @product2.id, :quantity => 2, :price => 111 }]}}, {'HTTP_AUTHORIZATION' => "Token token=#{@token}"}
         }.to change(LkOrder, :count).by(1) && change(LkOrderItem, :count).by(2)
        response.code.should eq("200")
      end      
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
