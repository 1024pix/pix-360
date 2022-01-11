# frozen_string_literal: true

class FeedbacksController < ApplicationController
  before_action :set_feedback, only: %i[show edit update destroy]

  def index
    @feedbacks = current_user.received_feedbacks
  end

  def show; end

  def new
    @feedback = Feedback.new
  end

  def edit; end

  def create
    @feedback = current_user.received_feedbacks.create_with_shared_key cookies[:encryption_password]

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
      if @feedback.update(feedback_params)
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
  end

  def feedback_params
    params.fetch(:feedback, {})
  end
end
