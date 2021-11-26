# frozen_string_literal: true

class EncryptionController < ApplicationController
  skip_before_action :provide_encryption_password, only: [:password, :save]

  def password; end

  def save
    if current_user.valid_password?(password_params)
      cookies[:encryption_password] = password_params
      redirect_to home_private_url, notice: 'Votre mot de passe a bien été envoyé'
    else
      flash[:alert] = 'Le mot de passe saisie ne correspond pas.'
      render :password
    end
  end

  private

  def password_params
    params.require(:user).permit(:password)
    params[:user][:password]
  end
end
