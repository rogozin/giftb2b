#encoding: utf-8;
Giftr3::Application.routes.draw do
  root :to => 'main#index'
  match 'admin' => 'admin/products#index', :as => :admin
  mount Lk::Engine => "/lk", :as => :lk_engine
  mount Auth::Engine => "/auth", :as => :auth_engine

  resources :main, :only => [:index] do
    get :change_scrollable, :on => :collection
  end
  resources :orders, :only => [:create, :index, :show], :controller => :user_orders do
    get :complete, :on => :collection
  end
 
  namespace :api do
    resources :categories, :only => [:index, :show] do
      collection do 
        get :thematics
        get :analogs
        get :virtuals        
      end
    end
    resources :products, :only => [:index, :show] do
      collection do 
        get :novelty
        get :sale
        get :lk
      end
    end
    resources :search, :only => [:index]
    resources :orders, :only => [:create]
    
  end
   
  namespace :admin do
    resources :firms do
      member do
        post :add_image
        delete :remove_image
      end 
    end   
    resources :accounts do   
      member do
          put :activate
        end
      end
    resources :banners do 
      
    end
    resources :main
    resources :news
    resources :categories  do    
      member do
        get :show_products_list
        post :change_category_products
        post :move
        post :add_image
        delete :remove_image
        post :change_sort
        get :child_items
      end    
      collection do
        get :catalog
        get :thematic
        get :analogs
        get :virtuals
      end
    end
    resources :contents
    resources :content_categories
    resources :content_images, :only => [:index, :create, :destroy] do
      collection do 
        get :galery
      end
    end
    resources :manufactors
    resources :suppliers do 
      resources :stores, :except => [:index, :show]
      member do 
        get :truncate_products
      end
    end
    resources :images do
      collection do
        get :all
      end
    end
    resources :currency_values, :only => [:index, :create, :destroy] do
      get :cbrf_tax, :on => :collection
    end
    resources :products do    
      member do
        put :activate
        get :inline_property_values
        post :update_inline
      end
      post :group_ops, :on => :collection  
      post :fields_settings, :on => :collection
      resources :images do
        member do
          delete :remove
          get :set_main
        end
      end
    end
    resources :properties do  
      resources :values, :controller => "property_values" do 
        member do
          post :join
        end
      end
      member do
        get :load_filter_values
      end
    end
    resources :data_changes do
      collection do
        post :import
        get :get_status
      end    
      member do 
        get :stop
      end
    end
    resources :export_data do
      collection do
        post :export
        get :permalinks
      end        
    end
    resources :foreign_access
    resources :services
    resources :roles
  end
end
