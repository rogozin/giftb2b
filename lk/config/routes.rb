Lk::Engine.routes.draw do
  root :to => "base#index"
  match 'profile' => "profile#edit", :as => :profile
  match 'change_profile' => 'profile#update', :as => :change_profile
#  resources :lk, :only =>[:index]
    match 'load_cart_products' =>  'base#load_cart_products', :as => :cart_products    
    resources :accounts
    resources :firms
    resources :products
    match 'load_lk_products' =>  'products#load_lk_products', :as => :load_products    
    resources :orders do
      member do
        post :calculate
        post :add_product        
      end
    end    
    resources :user_orders, :only => [:create, :index, :show] do
      get :complete, :on => :collection
    end
    resources :commercial_offers do
      member do 
        post :calculate
        post :add_product
        post :move_to_order
        get :export
      end
    resources :products, :controller => "commercial_offer_items", :only => [:edit, :destroy] 
    end  
    resources :samples    
end
