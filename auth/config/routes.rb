Auth::Engine.routes.draw do

  devise_for :users

   devise_scope :user do
      get 'login' =>  "sessions#new", :as => :login
      get 'logout', :to => "sessions#destroy", :as => :logout
      post 'signin' => "sessions#create", :as => :user_session      
      get 'users/register' => "users#new", :as => :new_refinery_user_registration
      post 'users/register' => "users#create", :as => :refinery_user_registration
    end

#  match 'login' => 'user_session#new', :as => :login
#  match 'logout' => 'user_session#destroy', :as => :logout
#  match 'register' => "users#new", :as => :register_user
#  match 'recovery' => "users#recovery", :as => :recovery_password
#  match 'activate/:activation_code' => "users#activate", :as => :activate_user
#  match 'user_session' => "user_session#create", :as => :create_session
#  match 'login/:token' => "users#login_by_token", :as => :login_by_token
#  #resource :user_session
#  match 'profile' => "profile#edit", :as => :profile
#  match 'change_profile' => 'profile#update', :as => :change_profile
#  post 'who_are_you' => "users#who_are_you", :as => :who_are_you
#  resources :users, :only => [:create, :edit, :update] do 
#    post :change_password, :on => :collection
#  end
end
