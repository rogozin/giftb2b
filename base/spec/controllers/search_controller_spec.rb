#encoding: utf-8;
require 'spec_helper'

describe SearchController do
#  render_views
#  let(:page) { Capybara::Node::Simple.new(@response.body) }

  before(:each) do
    @category = Factory(:category)
    @thematic = Factory(:category, :kind => 2)
    @analog = Factory(:category, :kind => 3)
    @manufactor = Factory(:manufactor)
    @s1= Factory(:supplier)
    @s2= Factory(:supplier)
    @p1 = Factory(:product, :categories => [@category], :supplier => @s1, :manufactor => @manufactor)
    @p2 = Factory(:product, :categories => [@category], :supplier => @s2)
    @cp = Factory(:color_property, :name => "Цвет")
    @color1 = @cp.property_values.create(:value => "Черный", :note => "#000000")
    @infliction = Factory(:text_property, :name => "Нанесение")
    @material = Factory(:text_property, :name => "Материал")
    @val1 = @material.property_values.create(:value => "Пластик")
    @val2 = @material.property_values.create(:value => "Дерево")    
  end

  def add_supplier_to_user(sup)
   @user.role_objects << Role.create(:name => sup.name, :description => sup.name, :group => 5, :authorizable_id => sup.id, :authorizable_type => "Supplier")
  end
  
  describe "GIFTB2B" do
    before(:each) do
      Settings.stub(:giftb2b?).and_return(true)
      Settings.stub(:giftpoisk?).and_return(false)
    end
    
    it 'response should success' do
      get :index
      response.should be_success 
      assigns(:color).should eq @cp
      assigns(:suppliers).should be_nil
      assigns(:manufactors).should be_nil
      assigns(:infliction).should be_nil
      assigns(:material).should be_nil      
    end    
    
  end
  
  
  describe "GIFTPOISK" do
    before(:each) do
      Settings.stub(:giftb2b?).and_return(false)
      Settings.stub(:giftpoisk?).and_return(true)
    end
    
    context "GET INDEX" do
      it 'response should 401 when no auth' do
        get :index
        response.should redirect_to "/auth/login"
      end    
      
      it 'response should success when auth' do
        direct_login_as :firm_manager
        add_supplier_to_user(@s1) 
        get :index
        response.should be_success 
        assigns(:color).should eq @cp
        assigns(:suppliers).should eq [@s1]
        assigns(:infliction).should eq @infliction
        assigns(:material).should eq @material     
      end    
    end

    describe 'POST INDEX' do
      
      context 'интернет-магазин' do
        before(:each) do
          direct_login_as :user
          @user.role_objects << Factory(:r_orders)
        end
        
        it 'при наличии роли "Мои заказы" возможен поиск по коду товара через форму расш. поиска' do
          post :index, :article => @p1.unique_code
          response.should be_success
          assigns(:products).should eq [@p1]          
        end
        
        it 'при этом поиск по артикулу поставщика не работает' do
          post :index, :article => @p1.article
          response.should be_success          
          assigns(:products).should be_empty          
        end
      end
      
      context "as firm manager" do      
        before(:each) do
            direct_login_as :firm_manager
        end
        
        it 'товар в евро, цена ищится нормально' do
          CurrencyValue.stub(:kurs).with("EUR").and_return(40)
          CurrencyValue.stub(:kurs).with("RUB").and_return(1)
          @p1.update_attributes(:currency_type => "EUR", :price => 10)
          @p2.update_attributes(:currency_type => "RUB", :price => 10)          
          post :index, :price_from => 0, :price_to => 20
          response.should be_success
          assigns(:products).should eq [@p2]
        end
        
        it 'search by supplier' do
          add_supplier_to_user(@s1)        
          post :index, :supplier_ids => [@s1.id, @s2.id]
          response.should be_success
          assigns(:products).should eq [@p1]
        end
        
        it 'search_by_article assigned supplier' do
          add_supplier_to_user(@s1)        
          post :index, :article => @p1.article
          assigns(:products).should eq [@p1]
        end
        
        it 'search_by_article unassigned supplier' do
          add_supplier_to_user(@s1)        
          post :index, :article => @p2.article
          assigns(:products).should eq []
        end      
      end
            
    end
    
  end  
end
