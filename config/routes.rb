Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'

  get '/login',     to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  get '/logout',   to: "sessions#destroy"

  get 'register', :to => 'users#new'
  get 'sign_in',    :to => 'sessions#new'

  resources :videos, only: [:show] do
    collection do
       post 'search', to: "videos#search"
    end
  end

  resources :categories, only: :show
  resources :users, only: [:new, :create]
  resources :videos, only: :index
end
