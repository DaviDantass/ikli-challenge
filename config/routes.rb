Rails.application.routes.draw do
  root "imports#new"
  resources :imports, only: %i[new create]
  resource :registration, only: %i[new create]
  resource :session, only: %i[new create destroy]
end
