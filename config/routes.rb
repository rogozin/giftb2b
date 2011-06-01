Giftr3::Application.routes.draw do



  root :to => 'main#index'
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'admin' => 'admin/products#index', :as => :admin
  match 'search' => 'main#search', :as => :search
  match 'profile' => "profile#edit", :as => :profile
  match 'change_profile' => 'profile#update', :as => :change_profile
  match 'register' => "users#new", :as => :register_user
  match 'activate/:activation_code' => "users#activate", :as => :activate_user
  match 'p/:id' => "content#show", :as => :content
  match 'c/:id' => "content_category#show", :as => :content_category
  resources :main, :only => [:index] do
    get :change_scrollable, :on => :collection
  end
  resource :user_session
  resources :users, :only => [:create, :edit, :update]
  resources :products
  resources :categories do
    collection do 
      get :on_sale
      get :best_price
    end 
  end
  
  namespace :api do
    resources :categories, :only => [:index, :show] do
      collection do 
        get :thematic
        get :analogs
        get :virtuals        
      end
    end
    resources :products, :only => [:index, :show]
    resources :search, :only => [:show]
    
  end
  
  resources :firms, :only => [:index, :show] do
    member do 
      get :city
    end
    collection do
      get :select_town
    end
  end
  resources :foreign do
    collection do
      get :search
      get :tree
      get :analog_tree
      get :thematic_tree
      get :virtual  
    end
    member do
      get :product
    end 
  end
  resources :cart, :only => [:index, :destroy] do
    post :add, :on => :member
    post :empty, :on => :collection
    post :calculate, :on => :collection
  end
  resources :lk, :only =>[:index]
  namespace :lk do
    resources :accounts
    resources :firms
    resources :products
    resources :orders do
      member do
        post :calculate
      end
    end
    resources :user_orders, :only => [:create, :index, :show]
    resources :commercial_offers do
      member do 
        post :calculate
        post :add_product
        get :export
      end
     get :load_lk_products
     get :load_cart_products
    resources :products, :controller => "commercial_offer_items", :except => [:index] 
    end  
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
    resources :main
    resources :categories  do    
      member do
        post :move
        post :add_image
        delete :remove_image
        post :change_sort
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
    resources :suppliers
    resources :images do
      collection do
        get :all
      end
    end
    resources :currency_values, :only => [:index, :create, :destroy] do
      get :cbrf_tax, :on => :collection
    end
    resources :products do    
      put :activate, :on => :member
      post :group_ops, :on => :collection  
      resources :images do
        member do
          delete :remove
          get :set_main
        end
      end
    end
    resources :properties do  
      resources :values
    end
    resources :data_changes do
      collection do
        post :import
        get :get_status
        get :cancel_thread
      end    
    end
    resources :export_data do
      collection do
        post :export
        get :permalinks
      end        
    end
    resources :foreign_access
  end

  match '/:controller(/:action(/:id))'
end

