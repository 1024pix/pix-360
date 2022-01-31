# frozen_string_literal: true

class ErrorsController < ApplicationController
  def not_found
    render template: 'errors/not_found', layout: 'layouts/error', status: :not_found
  end

  def internal_server
    render template: 'errors/not_found', layout: 'layouts/error', status: :internal_server_error
  end

  def unprocessable
    render template: 'errors/not_found', layout: 'layouts/error', status: :unprocessable_entity
  end

  def unacceptable
    render template: 'errors/not_found', layout: 'layouts/error', status: :not_acceptable
  end
end
