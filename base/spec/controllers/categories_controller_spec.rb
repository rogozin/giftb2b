#encoding: utf-8;
require 'spec_helper'

describe CategoriesController do
#  render_views
#  let(:page) { Capybara::Node::Simple.new(@response.body) }
  
  describe "GET Show" do
    before(:each) do
      @category = Factory(:category)
      @s1= Factory(:supplier)
      @s2= Factory(:supplier)
      @p1 = Factory(:product, :categories => [@category], :supplier => @s1)
      @p2 = Factory(:product, :categories => [@category], :supplier => @s2)
     #direct_login_as :firm_manager
    end
    
    
    context 'на сайте giftb2b' do
      before(:each) do
        Settings.stub(:gifb2b?).and_return(true)
        Settings.stub(:giftpoisk?).and_return(false)
      end        

      it 'я вижу товары обоих поставщиков' do
        get :show, :id => @category.permalink
        assigns(:category).should eq @category
        assigns(:products).should have(2).items
      end
    end
    
    
    context 'на сайте giftpoisk' do
      before(:each) do
        Settings.stub(:gifb2b?).and_return(false)
        Settings.stub(:giftpoisk?).and_return(true)
      end        

      it 'без авторизации я ничего не увижу' do
        get :show, :id => @category.permalink
        response.should redirect_to "/auth/login"
      end
      
      it 'я вижу только товары назначенных мне посавтщиков' do
        direct_login_as :firm_manager
        @user.role_objects << Role.create(:name => @s1.name, :description => @s1.name, :group => 5, :authorizable_id => @s1.id, :authorizable_type => "Supplier")
        get :show, :id => @category.permalink
        assigns(:category).should eq @category
        assigns(:products).should eq [@p1]
      end
      
    end    
    
  end  
end

