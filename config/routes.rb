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

  resources :sessions, only: :new

  resources :votings do
    resources :questions
    post 'vote', to: 'votings#vote'
  end

  resources :groups do
    get 'current', on: :collection
    post 'reset_token', on: :collection
    get 'bulk_upload', on: :collection, to: 'groups#bulk_upload_show', as: :bulk_upload_show
    post 'bulk_upload', on: :collection, to: 'groups#bulk_upload_create', as: :bulk_upload_create
  end

  resources :organizations

  root to: 'sessions#new'
end
