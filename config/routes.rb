Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'videos#index'

  resources :videos

  resources :videos, only: [:show] do
    collection do
       post 'search', to: "videos#search"
    end
  end

  resources :categories
end
