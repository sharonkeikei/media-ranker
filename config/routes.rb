Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :works 
  resources :users
  resources :votes

  get "/login", to: "users#login_form", as "login"
  post "/login", to: "users#login"
  post "/logout", to: "users#logout"
  
  get '/homepages', to: 'homepages#index', as: 'homepages'
  root to: 'homepages#index'
end
