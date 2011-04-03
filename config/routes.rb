Saffron::Application.routes.draw do

  resources :users

  root :to => "pages#home"

  match "/wiki"    => "pages#wiki"
  match "/issues"  => "pages#issues"
  match "/contact" => "pages#contact"

  match "/register" => "users#new", :as => :register

  match "/auth/:provider/callback" => "sessions#create"
  match "/logout"                  => "sessions#destroy", :as => :logout
end
