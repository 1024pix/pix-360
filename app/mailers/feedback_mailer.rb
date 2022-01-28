# frozen_string_literal: true

class FeedbackMailer < ApplicationMailer
  default from: email_address_with_name('notification@pix.fr', 'Pix 360')

  def new_request_email
    @email = params[:email]
    @link  = params[:link]
    @user = params[:user]
    mail(to: @email, subject: "Demande d'évaluation - Pix 360 ")
  end

  def new_received_email
    @email = params[:email]
    @link  = params[:link]
    mail(to: @email, subject: 'Nouvelle évaluation reçue - Pix 360 ')
  end
end
