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

  #match '/:controller(/:action(/:id))'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
