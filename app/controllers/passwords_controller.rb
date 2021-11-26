# frozen_string_literal: true

class PasswordsController < ApplicationController
  skip_before_action :create_encryption_password, :provide_encryption_password, only: [:edit, :update]

  # TODO : move in EncryptionController

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(password_params)
      @user.create_encryption_keys
      redirect_to home_private_url, notice: 'Votre mot de passe a bien été ajouté'
    else
      render :edit
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :must_change_password)
  end
end
