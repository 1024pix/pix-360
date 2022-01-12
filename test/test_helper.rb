# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include Devise::Test::IntegrationHelpers
    include Warden::Test::Helpers

    def log_in(user)
      if integration_test?
        login_as(user, scope: :user)
      else
        sign_in(user)
      end
    end

    def set_encryption_password_cookie
      patch encryption_save_url,
            params: { user: { password: '123456' } }
    end

    def sign_in_and_set_encryption(user)
      @user = user
      sign_in @user
      @user.password = '123456'
      @user.create_encryption_keys
      patch encryption_save_url,
            params: { user: { password: '123456' } }
    end
  end
end
