Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#home'
  get '/signup' => 'users#new'
  get '/login' => 'sessions#new'
  post '/logout' => 'sessions#destroy'
  resources :restrooms do
    resources :ratings
  end
  resources :locations, :neighborhoods, :users
  resources :tags, only: [:new, :create, :show]
  resources :sessions, only: [:new, :create, :destroy]
end
