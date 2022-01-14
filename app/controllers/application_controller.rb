# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :create_encryption_password, :provide_encryption_password

  private

  def create_encryption_password
    redirect_to encryption_edit_url if current_user.must_change_password
  end

  def provide_encryption_password
    redirect_to encryption_url unless cookies.encrypted[:encryption_password]
  end

  def encryption_ready?
    !current_user.must_change_password && cookies.encrypted[:encryption_password]
  end
end
