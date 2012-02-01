Lk::Engine.routes.draw do
 # mount Auth::Engine => "/auth", :as => :auth_engine
  root :to => "base#index"
#  resources :lk, :only =>[:index]
    match 'load_cart_products' =>  'base#load_cart_products', :as => :cart_products    
    match 'profile' => "profile#edit", :as => :profile
    put 'change_profile' => "profile#update", :as => :change_profile
    
    resources :accounts
    resources :firms
    resources :news do
      member do 
        put :send_to_moderate
        put :remove_from_moderate
      end
      collection do 
        get :drafts
        get :moderate
        get :published
        get :archived
      end
    end
    resources :products
    match 'load_lk_products' =>  'products#load_lk_products', :as => :load_products    
    resources :orders do
      member do
        post :calculate
        post :add_product        
      end
    end    

    resources :commercial_offers do
      member do 
        post :calculate
        post :modify
        post :add_product
        post :move_to_order
        get :export
      end
      resources :products, :controller => "commercial_offer_items", :only => [:edit, :destroy]
      resources :logos, :only => [:show, :update] do
        post :load, :on => :member
      end 
    end  
    resources :samples

    post 'commercial_offer/calc_single/:id' =>  'commercial_offer_items#calc_single'
end
