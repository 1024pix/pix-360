# frozen_string_literal: true
require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get root_url
    assert_response :success
  end

  setup do
    sign_in users(:one)
  end

  test 'should get private' do
    get home_private_url
    assert_response :success
  end
end
