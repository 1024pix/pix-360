# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

class JsonLogSerializer < ActiveSupport::Logger::SimpleFormatter
  def call(severity, timestamp, _progname, message)
    {
      level: severity,
      time: timestamp,
      message: message
    }.to_json + $INPUT_RECORD_SEPARATOR
  end
end

module Pix360
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.exceptions_app = routes

    config.i18n.default_locale = :fr
    config.log_formatter = JsonLogSerializer.new
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
