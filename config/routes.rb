Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get '/login',          to: 'sessions#new'
  post '/login',        to: 'sessions#create'
  get '/logout',        to: "sessions#destroy"
  get 'sign_in',         to: 'sessions#new'

  get 'register',       to:  'users#new'
  resources :users, only: [:new, :create, :show]

  get '/home',         to:  'videos#index'
  get 'my_queue',    to: "queue_videos#index"
  get 'people',         to: "relationships#index"
  resources :relationships, only: [:create, :destroy]

  get 'forgot_password', to:'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'

  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired_token'

  resources :videos, only: [ :index, :show ] do
    collection do
       post 'search',   to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  resources :categories, only: :show
  resources :queue_videos, only: [:create, :destroy]
  post 'update_queue', to: 'queue_videos#update_queue'

  resources :invitations, only: [:new, :create]

  root to: 'pages#front'
end
