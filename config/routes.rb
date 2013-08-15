Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get '/login',     to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  get '/logout',   to: "sessions#destroy"
  get 'sign_in',   :to => 'sessions#new'

  get 'register',  :to => 'users#new'
  resources :users, only: [:new, :create]

  get '/home',    :to => 'videos#index'

  resources :videos, only: [ :index, :show ] do
    collection do
       post 'search', to: "videos#search"
    end
    resources :reviews, only: :create
  end

  resources :categories, only: :show

  root to: 'pages#front'
end
