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

    context 'POST INDEX' do
      before(:each) do
          direct_login_as :firm_manager
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
