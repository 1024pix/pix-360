# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :create_encryption_password, :provide_encryption_password

  private

  def create_encryption_password
    if current_user.must_change_password
      redirect_to encryption_edit_url
    end
  end

  def provide_encryption_password
    unless cookies[:encryption_password]
      redirect_to encryption_url
    end
  end
end
