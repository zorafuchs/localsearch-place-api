Rails.application.routes.draw do
  resources :places, only: :show
end
