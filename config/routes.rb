# frozen_string_literal: true

Rails.application.routes.draw do
  resources :feedbacks do
    collection do
      get 'given'
    end
  end
  get 'encryption', to: 'encryption#index'
  patch 'encryption/save'
  get 'encryption/edit'
  patch 'encryption/update'

  delete 'users/delete', to: 'users#delete'

  devise_for :users, skip: %i[users registrable password], controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # Handling errors
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#not_found'
  get '/406', to: 'errors#not_found'
  get '/500', to: 'errors#not_found'

  root to: redirect('/feedbacks')

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
