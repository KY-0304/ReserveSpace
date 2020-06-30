Rails.application.routes.draw do
  devise_for :owners, controllers: {
    registrations: 'owners/registrations',
    sessions: 'owners/sessions',
  }
  root 'static_pages#home'
end
