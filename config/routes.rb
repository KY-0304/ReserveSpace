Rails.application.routes.draw do
  devise_for :owners, module: 'owners'
  devise_scope :owner do
    post 'owners/guest_sign_in', to: 'owners/sessions#guest_sign_in'
  end
  devise_for :users, module: 'users'
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  root 'static_pages#home'
  get  '/search', to: 'static_pages#search'

  resources :spaces do
    resources :reviews, only: [:create, :destroy], shallow: true
  end
  namespace :owners do
    resources :reservations, only: :index, shallow: true
  end
  namespace :users do
    resources :reservations, only: [:index, :new, :create, :destroy], shallow: true
    resources :favorites, only: [:index, :create, :destroy], shallow: true
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  match "*path" => "application#error404", via: :all
end
