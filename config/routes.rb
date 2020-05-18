Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :works 
  resources :users
  resources :votes

  get '/homepages', to: 'homepages#index', as: 'homepages'
  root to: 'homepages#index'
end
