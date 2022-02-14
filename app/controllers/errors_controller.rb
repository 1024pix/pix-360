# frozen_string_literal: true

class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!, :create_encryption_password, :provide_encryption_password

  def not_found
    render layout: 'error', status: :not_found
  end
end
