# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    skip_before_action :create_encryption_password, :provide_encryption_password, only: %i[new destroy]
    helper_method :from_feedback?, :feedback_id, :shared_key

    def destroy
      cookies.delete(:encryption_password)
      super
    end

    private

    def from_feedback?
      !!params[:feedback]
    end

    def feedback_id
      params[:feedback]
    end

    def shared_key
      params[:shared_key]
    end
  end
end
