# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      namespace :users do
        devise_scope :user do
          post 'login', to: 'sessions#create'
        end
      end
    end
  end

  resources :votings do
    resources :questions
    post 'vote', to: 'votings#vote'
  end
  resources :groups
  root to: 'votings#index'
end
