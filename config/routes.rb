Rails.application.routes.draw do
  devise_for :owners, module: 'owners'
  devise_for :users,  module: 'users'

  root 'static_pages#home'
  get  '/search', to: 'static_pages#search'
  get  '/about',  to: 'static_pages#about'

  resources :spaces do
    resources :reviews,      only: [:create, :destroy], shallow: true
    resource  :setting,      only: [:edit, :update]
    resources :reservations, only: :index do
      collection do
        post 'search'
      end
    end
  end

  namespace :owners do
    resources :guests, only: :create
  end

  namespace :users do
    resources :reservations, only: [:index, :new, :create, :destroy], shallow: true
    resources :favorites,    only: [:index, :create, :destroy],       shallow: true
    resources :guests,       only: :create
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  match "*path" => "application#error404", via: :all unless Rails.env.development?
end
