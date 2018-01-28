Rails.application.routes.draw do
  root to: 'welcome#home'

  get '/signup' => 'users#new'
  get '/login' => 'sessions#new'
  post '/logout' => 'sessions#destroy'
  get '/auth/google_oauth2/callback' => 'sessions#create'

  get '/restrooms/top-five' => 'restrooms#top_five'
  get '/restrooms/by-distance' => 'restrooms#by_distance'

  resources :restrooms do
    resources :ratings, except: [:new, :show]
  end
  
  resources :neighborhoods, except: [:new]
  resources :users
  resources :tags, only: [:index, :show, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
end
