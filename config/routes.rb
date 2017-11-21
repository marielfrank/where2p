Rails.application.routes.draw do
  root to: 'welcome#home'

  get '/signup' => 'users#new'
  get '/login' => 'sessions#new'
  post '/logout' => 'sessions#destroy'
  get '/auth/google_oauth2/callback' => 'sessions#create'

  get '/restrooms/top_five' => 'restrooms#top_five'

  resources :restrooms do
    resources :ratings, except: [:new, :show]
  end
  
  resources :neighborhoods, except: [:new]
  resources :users, except: [:show]
  resources :tags, only: [:index, :show, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
end
