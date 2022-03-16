Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :auth, only: %i[create destroy]
  resources :users, only: %i[show create destroy update]
  resources :users, param: :name, only: %i[show] do
    resources :posts, only: %i[index show create destroy update]
  end
  resources :users, param: :name, only: %i[show] do
    resources :posts, param: :id, only: %i[show] do
      delete 'category/:tag_id', to: 'posts#remove_category'
    end
  end
  get '/search/users', to: 'search_users#index'
  get '/search/posts', to: 'search_posts#index'
  post '/account/want_to_create', to: 'user_creation#create'
  get '/categories', to: 'category#index'
  get '/search/categories', to: 'category#search'

  if Rails.env == 'development'
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
