# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    skip_before_action :create_encryption_password, :provide_encryption_password, only: [:destroy]
  end
end
