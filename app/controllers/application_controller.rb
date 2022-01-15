# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :store_location, :authenticate_user!, :create_encryption_password, :provide_encryption_password

  private

  def create_encryption_password
    redirect_to encryption_edit_url if user_signed_in? && current_user.must_change_password
  end

  def provide_encryption_password
    redirect_to encryption_url if user_signed_in? && !cookies.encrypted[:encryption_password]
  end

  def encryption_ready?
    !current_user.must_change_password && cookies.encrypted[:encryption_password]
  end

  def store_location
    session[:return_to] = request.fullpath if request.get? && !%w[user_sessions sessions omniauth_callbacks
                                                                  encryption].include?(controller_name)
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
  end
end
