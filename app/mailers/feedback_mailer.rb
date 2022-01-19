# frozen_string_literal: true

class FeedbackMailer < ApplicationMailer
  default from: 'feedbacks@example.com'

  def feedback_email
    @email = params[:email]
    @link  = params[:link]
    @user = params[:user]
    mail(to: @email, subject: "Demande d'évaluation - Pix 360 ")
  end
end
