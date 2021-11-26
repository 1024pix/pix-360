# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get root_url
    assert_response :success
  end

  setup do
    sign_in users(:two)
    cookies[:encryption_password] = 'pa$$word'
  end

  test 'should get private after login' do
    get home_private_url
    assert_response :success
  end
end
