class HomeController < ApplicationController

  before_action :authentication_user!, only: [:private]

  def index
  end

  def private
  end
end
