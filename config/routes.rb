Rails.application.routes.draw do
  root to: 'polls#current'

  get '/signup' => 'users#new', as: 'signup'
  post '/users' => 'users#create', as: 'create_user'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  resources :polls
  post '/poll/:id/change_status/:event' => 'polls#change_status',
    as: :poll_change_status
  get '/user/:user_id/polls' => 'polls#index', as: 'user_polls'

  post 'vote/:option_id' => 'votes#create', as: 'create_vote'
end
