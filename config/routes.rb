Rails.application.routes.draw do
  devise_for :owners, controllers: {
    registrations: 'owners/registrations',
    sessions: 'owners/sessions',
    passwords: 'owners/passwords',
  }

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
  }
  root 'static_pages#home'
  resources :rooms do
    resources :reservations, except: [:edit, :update], shallow: true
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
