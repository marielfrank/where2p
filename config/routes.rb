Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#home'
  get '/signup' => 'user#new'
  get '/login' => 'session#new'
  post '/logout' => 'session#destroy'
  resources :restroom, :location, :neighborhood, :tag, :rating, :user
  resources :session, only: [:new, :create, :destroy]
end
