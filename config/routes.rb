Rails.application.routes.draw do
  root to: 'welcome#home'

  get '/signup' => 'users#new'
  get '/login' => 'sessions#new'
  post '/logout' => 'sessions#destroy'
  get '/auth/google_oauth2/callback' => 'sessions#create'

  resources :restrooms do
    resources :ratings
  end
  
  resources :neighborhoods, :users
  resources :tags, only: [:new, :create, :show]
  resources :sessions, only: [:new, :create, :destroy]
end
