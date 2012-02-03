#encoding:utf-8;
require 'spec_helper'

describe Lk::NewsController do

  def valid_attributes
    {:title => "Новость"}
  end
    
  describe 'LOGIN as supplier' do
    before(:each) do
      direct_login_as :supplier_manager  
    end
    
      it "index should be successful" do
        n = Factory(:news, :firm_id => @user.firm_id)
        get 'index'
        response.should be_success
      end
      
      it 'Созданная новость должна распологатся на гифтпоиске' do
        post :create, :news => valid_attributes
        Settings.stub(:site_id).and_return(1)
        assigns(:news).should be_a(News)
        assigns(:news).should be_persisted        
        assigns(:news).state_id.should eq(3)
        assigns(:news).created_by.should eq(@user.id)
        assigns(:news).firm_id.should eq(@user.firm_id)
        assigns(:news).site.should eq 1
        response.should redirect_to drafts_news_index_path
      end
    
  end
  
  describe 'LOGIN as firm_manager' do
      
    before(:each) do     
      direct_login_as :firm_manager
    end

    describe "GET 'index'" do
      it "index should be successful" do
        n = Factory(:news, :firm_id => @user.firm_id)
        get 'index'
        response.should be_success
      end
    
      it "drafts should be successful" do
        #сначала отклоненные, потом черновики
        n = Factory(:news, :firm_id => @user.firm_id, :state_id => 3)
        n1= Factory(:news, :firm_id => @user.firm_id, :state_id => 4)
        get 'drafts'
        response.should be_success
        assigns(:news).should eq([n1, n])
      end
      
      it "moderate should be successful" do
        n = Factory(:news, :firm_id => @user.firm_id, :state_id => 0)
        get 'moderate'
        response.should be_success
        assigns(:news).should eq([n])
      end

      it "published should be successful" do
        n = Factory(:news, :firm_id => @user.firm_id, :state_id => 1)
        get 'published'
        response.should be_success
        assigns(:news).should eq([n])
      end

      it "archived should be successful" do
        n = Factory(:news, :firm_id => @user.firm_id, :state_id => 2)
        get 'archived'
        response.should be_success
        assigns(:news).should eq([n])
      end

          
    end


  describe "POST create" do
      describe "with valid params" do
        it "creates a new News" do
          expect {
            post :create, :news => valid_attributes
          }.to change(News, :count).by(1)
        end

        it "создать новость как черновик" do
         Settings.stub(:site_id).and_return(0)
          post :create, :news => valid_attributes
          assigns(:news).should be_a(News)
          assigns(:news).should be_persisted        
          assigns(:news).state_id.should eq(3)
          assigns(:news).site.should eq(0)
          assigns(:news).created_by.should eq(@user.id)
          assigns(:news).firm_id.should eq(@user.firm_id)
          response.should redirect_to drafts_news_index_path
        end
        
        it 'создать и отправить на модерацию' do
          firm  = Factory(:firm)
          @user.update_attribute :firm_id, firm.id
          @admin = Factory(:admin)        
          post :create, :news => {:title => "Новость"}, :moderate => "На модерацию"
          assigns(:news).should be_a(News)
          assigns(:news).should be_persisted        
          assigns(:news).state_id.should eq(0)
          assigns(:news).created_by.should eq(@user.id)
          assigns(:news).firm_id.should eq(@user.firm_id)
          ActionMailer::Base.deliveries.should have(1).item      
          response.should redirect_to moderate_news_index_path        
        end
      end
      
       describe "with invalid params" do
        it "assigns a newly created but unsaved news as @news" do
          # Trigger the behavior that occurs when invalid params are submitted
          News.any_instance.stub(:save).and_return(false)
          post :create, :news => {}
          assigns(:news).should be_a_new(News)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          News.any_instance.stub(:save).and_return(false)
          post :create, :news => {}
          response.should render_template("new")
        end
      end
      
    end
    
    
    describe "GET edit" do
      it 'Редактирование черновика новости' do
        news = Factory(:news, :firm_id => @user.firm_id, :state_id => 3)
        get :edit, :id => news.permalink
        response.should be_success
        assigns(:news).should eq(news)
        response.should render_template("edit")      
      end
      
      it 'попытка отредактировать опубликованную новость' do
        news = Factory(:news, :firm_id => @user.firm_id, :state_id => 0)
        get :edit, :id => news.permalink
        assigns.should redirect_to news_index_path        
        flash[:alert].should_not be_nil      
      end
      
      it 'попытка открыть чужую новость для редактирования' do
        news = Factory(:news, :firm_id => 11, :state_id => 0)
        get :edit, :id => news.permalink
        response.should be_not_found           
      end
    end
      
     describe "PUT update" do
      describe "with valid params" do
      
        it "изменение черновика новости" do
          news = Factory(:news, :firm_id => @user.firm_id, :state_id => 3)
          put :update, :id => news.permalink, :news => {'title' => 'Супер нововсть'}
          assigns(:news).title.should eq("Супер нововсть")
          assigns.should redirect_to drafts_news_index_path
        end
        
        it "изменение черновика новости и отправка на модерацию" do
          firm  = Factory(:firm)
          @user.update_attribute :firm_id, firm.id
          @admin = Factory(:admin)        
          news = Factory(:news, :firm_id => @user.firm_id, :created_by => @user.id, :state_id => 3)
          put :update, :id => news.permalink, :news => {'title' => 'Супер нововсть'}, :moderate => "На модерацию"
          assigns(:news).title.should eq("Супер нововсть")
          assigns(:news).state_id.should eq 0
          ActionMailer::Base.deliveries.should have(1).item
          assigns.should redirect_to moderate_news_index_path
        end

        it "попытка изменение новости, отрпавленной на модерацию" do
          news = Factory(:news, :firm_id => @user.firm_id, :state_id => 0)
          put :update, :id => news.permalink, :news => {'title' => 'Супер нововсть'}
          assigns(:news).should eq(news)
          assigns.should redirect_to news_index_path        
          flash[:alert].should_not be_nil
        end
      end

      describe "with invalid params" do
        it "assigns the news as @news" do
          news = Factory(:news, :firm_id => @user.firm_id, :state_id => 3)
          # Trigger the behavior that occurs when invalid params are submitted
          News.any_instance.stub(:save).and_return(false)
          put :update, :id => news.permalink, :news => {}
          assigns(:news).should eq(news)
          response.should render_template("edit")        
        end

      end
    end  
      
      
    describe 'Moderate' do
      it 'Новость может быть отправлена на модерацию' do
        @news = Factory(:news, :firm_id => @user.firm_id, :state_id => 3)
        put :send_to_moderate, :id => @news.permalink
        response.should redirect_to drafts_news_index_path
        flash[:notice].should_not be_nil
        assigns(:news).state_id.should be(0)    
      end
      
      it 'при отправке новости на модерацию админу идет уведомление' do      
        @news = Factory(:news, :firm_id => @user.firm_id, :state_id => 3, :created_by => @user.id)
        firm  = Factory(:firm)
        @user.update_attribute :firm_id, firm.id
        @admin = Factory(:admin)
        put :send_to_moderate, :id => @news.permalink     
        ActionMailer::Base.deliveries.should have(1).items      
        ActionMailer::Base.deliveries.first.to.should eq([@admin.email])      
  #      ActionMailer::Base.deliveries.last.body.should match("Рекламное агентство")
  #      ActionMailer::Base.deliveries.first.body.should match(User.last.username)    
      end
      
      it 'Новость может быть снята с модерации' do
        @news = Factory(:news, :firm_id => @user.firm_id, :state_id => 0)
        put :remove_from_moderate, :id => @news.permalink
        response.should redirect_to moderate_news_index_path
        flash[:notice].should_not be_nil
        assigns(:news).state_id.should be(3)
      end

      it 'Новость не может быть снята с модерации если уже опубликована' do
        @news = Factory(:news, :firm_id => @user.firm_id, :state_id => 1 )
        put :remove_from_moderate, :id => @news.permalink
        response.should redirect_to news_index_path      
        flash[:alert].should_not be_nil
        assigns(:news).should eq(@news)
      end
      
    end  
    
    describe "delete" do 
      
      it 'Новость может быть удалена' do
        @news = Factory(:news, :firm_id => @user.firm_id, :state_id => 0)
        delete :destroy, :id => @news.permalink
        response.should redirect_to drafts_news_index_path
        flash[:notice].should_not be_nil
        assigns(:news).should be_destroyed
      end
    end
  end
    
end

