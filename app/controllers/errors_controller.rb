# frozen_string_literal: true

class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!

  def not_found
    render layout: 'error', status: :not_found
  end

  def internal_server
    render layout: 'error', status: :internal_server_error
  end

  def unprocessable
    render layout: 'error', status: :unprocessable_entity
  end

  def unacceptable
    render layout: 'error', status: :not_acceptable
  end
end
