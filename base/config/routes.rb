Rails.application.routes.draw do
  match 'search' => 'search#index', :as => :search
  match 'p/:id' => "content#show", :as => :content
  match 'c/:id' => "content_category#show", :as => :content_category
  match 's/:id' => "suppliers#show", :as => :supplier
  
  resources :products, :only => [:index, :show]
  resources :categories do
    collection do 
      get :on_sale
      get :best_price
    end 
  resources :search, :only => [:index]
  resources :orders, :only => [:create]    
  end
  
  resources :firms, :only => [:index, :show] do
    member do 
      get :city
    end
    collection do
      get :select_town
    end
  end

  resources :cart, :only => [:index, :destroy] do
    post :add, :on => :member
    post :empty, :on => :collection
    post :calculate, :on => :collection
  end

end
