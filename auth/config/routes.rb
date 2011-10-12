Auth::Engine.routes.draw do

  match 'login' => 'user_session#new', :as => :login
  match 'logout' => 'user_session#destroy', :as => :logout
  match 'register' => "users#new", :as => :register_user
  match 'recovery' => "users#recovery", :as => :recovery_password
  match 'activate/:activation_code' => "users#activate", :as => :activate_user
  match 'user_session' => "user_session#create", :as => :create_session
  match 'login/:token' => "users#login_by_token", :as => :login_by_token
  #resource :user_session
  match 'profile' => "profile#edit", :as => :profile
  match 'change_profile' => 'profile#update', :as => :change_profile
  post 'who_are_you' => "users#who_are_you", :as => :who_are_you
  resources :users, :only => [:create, :edit, :update] do 
    post :change_password, :on => :collection
  end
end
