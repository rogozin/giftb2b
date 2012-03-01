Auth::Engine.routes.draw do

  devise_for :users, {
    :class_name => 'User',
    :controllers => { 
      :passwords => 'auth/passwords',
      :sessions => 'auth/sessions' },
      :skip => [:sessions]        
   }

  as :user do
    get 'login' => 'sessions#new', :as => :new_user_session
    post 'login' => 'sessions#create', :as => :user_session
    delete 'logout' => 'sessions#destroy', :as => :destroy_user_session
    get 'recovery' => "passwords#new", :as => :recovery      
  end

  match 'register' => "users#new", :as => :register_user
  match 'profile' => "profile#edit", :as => :profile
  match 'change_profile' => 'profile#update', :as => :change_profile
  post 'who_are_you' => "users#who_are_you", :as => :who_are_you
  resources :users, :only => [:create, :edit, :update]
end
