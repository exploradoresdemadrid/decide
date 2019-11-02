Rails.application.routes.draw do
  devise_for :users
  resources :votings
  resources :groups
  root to: "home#index"
end
