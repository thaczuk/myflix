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
  resources :relationships, only: [:destroy]

  resources :videos, only: [ :index, :show ] do
    collection do
       post 'search',   to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  resources :categories, only: :show
  resources :queue_videos, only: [:create, :destroy]
  post 'update_queue', to: 'queue_videos#update_queue'

  root to: 'pages#front'
end
