Rails.application.routes.draw do

  resources :genres
  resource :session, only: [:new, :create, :destroy]
  get '/signin', to: "sessions#new"
  resources :users
  get '/signup', to: "users#new"
  get 'movies/filter/:filter', to: "movies#index", as: "filtered_movies"
  root "movies#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :movies do
    resources :favorites, only: [:create, :destroy]
    resources :reviews
  end
end
