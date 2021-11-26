# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :authenticate_user!, :create_encryption_password, :provide_encryption_password, only: [:index]

  def index; end

  def private; end
end
