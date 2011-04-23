Saffron::Application.routes.draw do

  resources :users
  resources :sessions,      :only => [ :new, :create, :destroy ]
  resources :projects

  root :to => "pages#home"

  match "/wiki"    => "pages#wiki"
  match "/issues"  => "pages#issues"
  match "/contact" => "pages#contact"

  match "/register" => "users#new"
  match "/login"    => "sessions#new"
  match "/logout"   => "sessions#destroy"
end
