# frozen_string_literal: true

class FeedbacksController < ApplicationController
  skip_before_action :authenticate_user!, only: :edit
  before_action :set_feedback, only: %i[show edit update destroy]
  before_action :should_seen_sign_in_page, only: :edit
  helper_method :edit_feedback_link

  def index
    @feedbacks = current_user.received_feedbacks
  end

  def show; end

  def new
    @feedback = Feedback.new
  end

  def edit
    if @feedback.already_edit_by_user? && user_signed_in? && @feedback.edited_by_user?(current_user.id)
      @feedback.decrypted_shared_key = params[:shared_key]
      @feedback.decrypt_content
      return
    end

    if !@feedback.already_edit_by_user? && @feedback.verify_shared_key(params[:shared_key])
      @feedback.decrypted_shared_key = params[:shared_key]
      @feedback.decrypt_content
      return
    end

    redirect_to feedbacks_url,
                { flash: { error: 'You are not allowed.' } }
  end

  def create
    @feedback = current_user.received_feedbacks.create_with_shared_key cookies.encrypted[:encryption_password]
    respond_to do |format|
      if @feedback.save
        format.html { redirect_to @feedback, notice: 'Feedback was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @feedback.update_content feedback_params
        format.html { redirect_to @feedback, notice: 'Feedback was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feedback.destroy
    respond_to do |format|
      format.html { redirect_to feedbacks_url, notice: 'Feedback was successfully destroyed.' }
    end
  end

  private

  def set_feedback
    @feedback = Feedback.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to feedbacks_url, flash: { error: 'Feedback not found.' }
  end

  def feedback_params
    params.fetch(:feedback, {}).permit(:decrypted_shared_key, content: %w[positive_points improvements_areas comments])
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
end
