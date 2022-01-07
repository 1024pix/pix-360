# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test '#destroy: should sign_out user ' do
    sign_in users(:two)
    delete destroy_user_session_url
    assert_redirected_to root_url
  end
end
