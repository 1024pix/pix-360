# frozen_string_literal: true

class EncryptionController < ApplicationController
  skip_before_action :create_encryption_password, only: %i[edit update]
  skip_before_action :provide_encryption_password, only: %i[index save edit update]
  before_action :encryption_already_set, only: %i[edit]

  def index; end

  def save
    password = params[:user][:password]
    if current_user.valid_password?(password)
      cookies.encrypted[:encryption_password] = password
      redirect_back_or_default root_url
    else
      flash[:alert] = 'Le mot de passe saisie ne correspond pas.'
      render :index
    end
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = current_user
    if @user.update(encryption_params)
      @user.create_encryption_keys
      cookies.encrypted[:encryption_password] = params[:user][:password]
      bypass_sign_in @user, scope: :user
      flash[:notice] = 'Votre mot de passe a bien été ajouté.'
      redirect_back_or_default root_url
    else
      render :edit
    end
  end

  private

  def encryption_params
    params.require(:user).permit(:password, :password_confirmation, :must_change_password)
  end

  def encryption_already_set
    redirect_to root_url if encryption_ready?
  end
end
