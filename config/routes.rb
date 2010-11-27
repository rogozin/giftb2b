Giftr3::Application.routes.draw do
  root :to => 'main#index'
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'admin' => 'admin/products#index', :as => :admin
  resources :main
  resource :user_session
  resources :users
  resources :products
  resources :categories
  resources :foreign do
    collection do
  get :search
  get :tree
  get :virtual
  end
    member do
  get :product
  end
  
  end

  resources :users
  namespace :admin do
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
      end    
      collection do
        get :catalog
        get :thematic
        get :analogs
        get :virtuals
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
      member do
          put :activate
        end
      resources :images do
        member do
          delete :remove
        end
      end
    end
    resources :properties do  
      resources :values
    end
    resources :data_changes do
      collection do
        post :import
      end    
    end
    resources :export_data do
      collection do
        post :export
      end        
    end
    resources :foreign_access
  end

  match '/:controller(/:action(/:id))'
end

