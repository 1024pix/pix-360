# frozen_string_literal: true

Rails.application.routes.draw do
  get 'encryption/password'
  patch 'encryption/save'

  devise_scope :user do
    get 'users/sign_in', to: 'home#index'
  end

  devise_for :users, skip: [:users, :registrable, :password], controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'home#index'

  get 'home/private'

  get 'passwords/edit'
  patch 'passwords/update'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
