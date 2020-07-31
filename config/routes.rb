Rails.application.routes.draw do
  devise_for :owners, module: 'owners'
  devise_for :users, module: 'users'

  root 'static_pages#home'
  resources :spaces do
    resources :reviews, only: [:create, :destroy], shallow: true
  end
  namespace :owners do
    resources :reservations, only: :index, shallow: true
  end
  namespace :users do
    resources :reservations, only: [:index, :create, :destroy], shallow: true
    resources :favorites, only: [:index, :create, :destroy], shallow: true
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
