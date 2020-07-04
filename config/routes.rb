Rails.application.routes.draw do
  devise_for :owners, controllers: {
    registrations: 'owners/registrations',
    sessions: 'owners/sessions',
    passwords: 'owners/passwords',
  }
  root 'static_pages#home'
  resources :owners, only: :index

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
