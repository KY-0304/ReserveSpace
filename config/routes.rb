Rails.application.routes.draw do
  devise_for :owners
  root 'static_pages#home'
end
