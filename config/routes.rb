# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.superadmin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users

  namespace :api do
    namespace :v1 do
      namespace :users do
        devise_scope :user do
          post 'login', to: 'sessions#create'
        end
      end
      resources :organizations, only: [] do
        put 'test', on: :collection, to: 'organizations#create_test'
      end
    end
  end

  resources :sessions, only: :new

  resources :organizations do
    resources :bodies
    resources :votings do
      resources :questions
      post 'vote', to: 'votings#vote'
    end

    resources :groups do
      get 'current', on: :collection
      post 'reset_token', on: :collection
      post 'email_token', on: :collection
      get 'bulk_upload/template', on: :collection, to: 'groups#bulk_upload_template', as: :bulk_upload_template
      get 'bulk_upload', on: :collection, to: 'groups#bulk_upload_show', as: :bulk_upload_show
      post 'bulk_upload', on: :collection, to: 'groups#bulk_upload_create', as: :bulk_upload_create
    end
  end
  root to: 'sessions#new'
end
