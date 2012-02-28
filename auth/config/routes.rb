Auth::Engine.routes.draw do

  devise_for :users

   devise_scope :user do
      get 'login' =>  "sessions#new", :as => :login
      delete 'logout', :to => "sessions#destroy", :as => :logout
      post 'signin' => "sessions#create", :as => :user_session      
      get 'recovery' => "passwords#new", :as => :recovery      
    end

  match 'register' => "users#new", :as => :register_user
  match 'profile' => "profile#edit", :as => :profile
  match 'change_profile' => 'profile#update', :as => :change_profile
  post 'who_are_you' => "users#who_are_you", :as => :who_are_you
  resources :users, :only => [:create, :edit, :update]
end
