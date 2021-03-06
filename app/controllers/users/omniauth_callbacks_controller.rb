# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :create_encryption_password, :provide_encryption_password, only: [:google_oauth2]

    def google_oauth2
      @user = User.from_google_oauth2(request.env['omniauth.auth'])
      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
      else
        session['devise.google_oauth2'] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
    end

    def after_sign_in_path_for(resource_or_scope)
      session[:return_to] || stored_location_for(resource_or_scope) || root_path
    end
  end
end
