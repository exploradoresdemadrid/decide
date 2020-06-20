# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :sessions, only: :new

  resources :votings do
    resources :questions
    post 'vote', to: 'votings#vote'
  end

  resources :groups do
    post 'reset_token', on: :collection
  end

  resources :organizations

  root to: 'sessions#new'
end
