# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class FeedbacksController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[edit update]
  before_action :set_feedback, only: %i[show edit update destroy]
  before_action :requester?, only: :show
  before_action :should_seen_sign_in_page, only: :edit
  before_action :should_be_editable, only: :update
  helper_method :edit_feedback_link

  def index
    @feedbacks = current_user.received_feedbacks.order(created_at: :desc)
  end

  def show
    shared_key = if @feedback.respondent_id
                   shared_key_with @feedback.respondent_id
                 else
                   @feedback.decrypt_shared_key cookies.encrypted[:encryption_password]
                 end
    decrypt_content shared_key
  end

  def new
    @feedback = Feedback.new
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def edit
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
    @feedback = current_user.received_feedbacks.create_with_shared_key cookies.encrypted[:encryption_password]
    if @feedback.save
      send_feedback_request_mail
      redirect_to @feedback, flash: { success: "L'évaluation a été demandée avec succès." }
    else
      flash[:error] = "Une erreur s'est produite durant la création de l'évaluation."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if params[:submit]
      update_content(true, "L'évaluation a bien été envoyée.",
                     "Une erreur s'est produite durant l'envoie de l'évaluation.")
    else
      update_content(false, "L'évaluation a bien été modifiée.",
                     "Une erreur s'est produite durant la mise à jour de l'évaluation.")
    end
  end

  def destroy
    @feedback.destroy
    redirect_to feedbacks_url, flash: { success: "L'évaluation a bien été supprimée." }
  end

  def given
    @feedbacks = current_user.given_feedbacks.order(created_at: :desc)
  end

  private

  def set_feedback
    @feedback = Feedback.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to feedbacks_url, flash: { error: "L'évaluation est introuvable." }
  end

  def feedback_params
    params.fetch(:feedback, {}).permit(:decrypted_shared_key,
                                       :recipient_email, content: %w[positive_points improvements_areas comments])
  end

  def requester?
    return if @feedback.requester_id == current_user.id

    redirect_to feedbacks_url,
                flash: { error: "Vous n'êtes pas autorisé à consulter cette évaluation." }
  end

  def edit_feedback_link(feedback)
    shared_key = feedback.decrypt_shared_key cookies.encrypted[:encryption_password]
    edit_feedback_url(id: feedback.id, shared_key: shared_key)
  end

  def should_seen_sign_in_page
    redirect_to new_user_session_url(feedback: params[:id], shared_key: params[:shared_key]) unless seen_sign_in_page?
  end

  def should_be_editable
    return unless @feedback.is_submitted

    redirect_to feedbacks_url,
                flash: { error: 'Cette évaluation a déjà été soumise.' }
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
                        email: feedback_params[:recipient_email]).feedback_email.deliver_now
  end

  def update_content(is_submitted, success_message, error_message)
    respondent_id = current_user ? current_user.id : nil
    if @feedback.update_content(feedback_params, respondent_id, is_submitted: is_submitted)
      redirect_to @feedback, flash: { success: success_message }
    else
      flash[:error] = error_message
      render :edit, status: :unprocessable_entity
    end
  end
end
# rubocop:enable Metrics/ClassLength
