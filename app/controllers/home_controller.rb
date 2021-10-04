# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:private]

  def index; end

  def private; end
end
