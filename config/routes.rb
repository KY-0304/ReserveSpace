Rails.application.routes.draw do
  devise_for :owners, module: 'owners'
  devise_for :users, module: 'users'

  root 'static_pages#home'
  resources :rooms
  namespace :owners do
    resources :reservations, only: [:index, :show], shallow: true
  end
  namespace :users do
    resources :reservations, only: [:index, :show, :create, :destroy], shallow: true
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
