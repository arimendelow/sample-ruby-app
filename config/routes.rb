Rails.application.routes.draw do
  get     'password_resets/new'
  get     'password_resets/edit'
  root    'static_pages#home'
  get     '/help'                           ,to: 'static_pages#help'
  get     '/about'                          ,to: 'static_pages#about'
  get     '/contact'                        ,to: 'static_pages#contact'
  get     '/signup'                         ,to: 'users#new'
  post    '/signup'                         ,to: 'users#create'
  get     '/login'                          ,to: 'sessions#new'
  post    '/login'                          ,to: 'sessions#create'
  delete  '/logout'                         ,to: 'sessions#destroy'
  # Need this for CRUD operations on a given user - see the CRUD table for the provided actions
  resources :users do
    # Makes it possible to have URLs such as /users/:id/following and /users/:id/followers
    member do
      get :following, :followers
    end
  end
  resources :account_activation,  only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
end
