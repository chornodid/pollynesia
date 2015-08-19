Rails.application.routes.draw do
  root to: 'polls#index'

  get '/signup' => 'users#new', as: 'signup'
  post '/users' => 'users#create', as: 'create_user'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
end
