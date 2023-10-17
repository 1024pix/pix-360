# frozen_string_literal: true

class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!, :create_encryption_password, :provide_encryption_password

  def not_found
    respond_to do |format|
      format.html { render layout: 'error', status: :not_found }
      format.all  { render nothing: true, status: :not_found }
    end
  end

  rescue_from(ActionController::RoutingError) do
    request.format = :html
    not_found
  end
end
