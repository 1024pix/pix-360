# frozen_string_literal: true

class CannotShowFeedback < StandardError
end

class CannotUpdateFeedback < StandardError
end

class CannotEditFeedback < StandardError
end

class CannotDestroyFeedback < StandardError
end

# rubocop:disable Metrics/ClassLength
class FeedbacksController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[edit update]
  before_action :should_seen_sign_in_page, only: :edit
  helper_method :edit_feedback_link

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to feedbacks_url, flash: { error: "L'évaluation est introuvable." }
  end

  rescue_from CannotShowFeedback do
    redirect_to feedbacks_url,
                flash: { error: "Vous n'êtes pas autorisé à consulter cette évaluation." }
  end

  rescue_from CannotUpdateFeedback do
    redirect_to feedbacks_url,
                flash: { error: 'Cette évaluation a déjà été soumise.' }
  end

  rescue_from CannotEditFeedback do
    redirect_to feedbacks_url,
                flash: { error: "Vous n'êtes pas autorisé à éditer votre évaluation." }
  end

  rescue_from CannotDestroyFeedback do
    redirect_to feedbacks_url,
                flash: { error: "Vous n'êtes pas autorisé à supprimer cette évaluation." }
  end

  def index
    encryption_password = cookies.encrypted[:encryption_password]
    @awaiting_feedbacks = current_user.received_feedbacks.not_submitted.order(created_at: :desc)
    @awaiting_feedbacks.each { |feedback| feedback.decrypt_respondent_information(encryption_password) }
    @submitted_feedbacks = current_user.received_feedbacks.submitted.order(updated_at: :desc)
    @submitted_feedbacks.each { |feedback| feedback.decrypt_respondent_information(encryption_password) }
  end

  def show
    @feedback = require_feedback!
    ensure_can_show!(@feedback)
    encryption_password = cookies.encrypted[:encryption_password]
    shared_key = if @feedback.respondent_id
                   shared_key_with @feedback.respondent_id
                 else
                   @feedback.decrypt_shared_key encryption_password
                 end
    decrypt_content shared_key
    @feedback.decrypt_respondent_information encryption_password
  end

  def new
    @feedback = Feedback.new
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def edit
    @feedback = require_feedback!
    ensure_can_edit!(@feedback)
    if @feedback.already_edit_by_user? && user_signed_in? && @feedback.edited_by_user?(current_user.id)
      shared_key = shared_key_with(@feedback.requester.id)
      decrypt_content shared_key
      return
    end

    if !@feedback.already_edit_by_user? && @feedback.verify_shared_key(params[:shared_key])
      decrypt_content params[:shared_key]
      @feedback.decrypted_shared_key = shared_key_with(@feedback.requester.id) if user_signed_in?
      return
    end

    redirect_to feedbacks_url,
                { flash: { error: "Vous n'êtes pas autorisé à éditer cette évaluation." } }
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def create
    @feedback = current_user.received_feedbacks.create_with_shared_key(feedback_params,
                                                                       cookies.encrypted[:encryption_password])
    if @feedback.save
      send_feedback_request_mail
      redirect_to @feedback, flash: { success: "L'évaluation a été demandée avec succès." }
    else
      flash[:error] = "Une erreur s'est produite durant la création de l'évaluation."
      render :new, status: :unprocessable_entity
    end
  end

  # rubocop:disable Metrics/MethodLength
  def update
    @feedback = require_feedback!
    ensure_can_update!(@feedback)

    if params[:submit]
      update_content(true, "L'évaluation a bien été envoyée.",
                     "Une erreur s'est produite durant l'envoie de l'évaluation.")
      FeedbackMailer.with(link: feedback_url(@feedback),
                          email: @feedback.requester.email).new_received_email.deliver_now
    else
      update_content(false, "L'évaluation a bien été modifiée.",
                     "Une erreur s'est produite durant la mise à jour de l'évaluation.")
    end
  end
  # rubocop:enable Metrics/MethodLength

  def destroy
    feedback = require_feedback!
    ensure_can_destroy!(feedback)
    feedback.destroy
    redirect_to feedbacks_url, flash: { success: "L'évaluation a bien été supprimée." }
  end

  def given
    @feedbacks = current_user.given_feedbacks.order(created_at: :desc)
  end

  private

  def require_feedback!
    Feedback.find(params[:id])
  end

  def feedback_params
    params.fetch(:feedback, {}).permit(:decrypted_shared_key, content: %w[positive_points improvements_areas comments],
                                                              respondent_information: %w[email full_name])
  end

  def ensure_can_show!(feedback)
    raise CannotShowFeedback if feedback.requester_id != current_user.id
  end

  def ensure_can_edit!(feedback)
    raise CannotEditFeedback unless !user_signed_in? || feedback.requester_id != current_user.id
  end

  def ensure_can_update!(feedback)
    raise CannotUpdateFeedback if feedback.is_submitted
  end

  def ensure_can_destroy!(feedback)
    raise CannotDestroyFeedback if feedback.requester_id != current_user.id
  end

  def edit_feedback_link(feedback)
    shared_key = feedback.decrypt_shared_key cookies.encrypted[:encryption_password]
    edit_feedback_url(id: feedback.id, shared_key: shared_key)
  end

  def should_seen_sign_in_page
    redirect_to new_user_session_url(feedback: params[:id], shared_key: params[:shared_key]) unless seen_sign_in_page?
  end

  def seen_sign_in_page?
    user_signed_in? || params[:external_user] == 'true'
  end

  def decrypt_content(shared_key)
    @feedback.decrypted_shared_key = shared_key
    @feedback.decrypt_content
  end

  def shared_key_with(user_id)
    current_user.password = cookies.encrypted[:encryption_password]
    current_user.shared_key_with user_id
  end

  def send_feedback_request_mail
    FeedbackMailer.with(link: edit_feedback_link(@feedback), user: current_user,
                        email: feedback_params[:respondent_information][:email]).new_request_email.deliver_now
  end

  def update_content(is_submitted, success_message, error_message)
    respondent_id = current_user ? current_user.id : nil
    if @feedback.update_content(feedback_params, respondent_id, is_submitted: is_submitted)
      flash[:success] = success_message
      redirect_after_update
    else
      flash[:error] = error_message
      render :edit, status: :unprocessable_entity
    end
  end

  def redirect_after_update
    if user_signed_in?
      redirect_to feedbacks_path
    else
      shared_key = params[:feedback][:decrypted_shared_key]
      redirect_to edit_feedback_path(id: @feedback.id, shared_key: shared_key, external_user: true)
    end
  end
end
# rubocop:enable Metrics/ClassLength
