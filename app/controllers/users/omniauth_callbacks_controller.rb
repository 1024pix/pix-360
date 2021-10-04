# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      @user = User.from_google_oauth2(request.env['omniauth.auth'])
      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
      else
        session['devise.google_oauth2'] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
    end
  end
end
