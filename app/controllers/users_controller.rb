# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :provide_encryption_password, only: [:delete]
  def delete
    @user = current_user
    @user.deprecate
    redirect_to destroy_user_session_path
  end
end
