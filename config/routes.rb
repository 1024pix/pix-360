# frozen_string_literal: true

Rails.application.routes.draw do
  get 'encryption', to: 'encryption#index'
  patch 'encryption/save'
  get 'encryption/edit'
  patch 'encryption/update'

  devise_for :users, skip: %i[users registrable password], controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'home#index'

  get 'home/private'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
