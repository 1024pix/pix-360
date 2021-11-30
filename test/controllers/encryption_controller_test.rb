# frozen_string_literal: true

require 'test_helper'

class EncryptionControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'should get password when user has sign in' do
    get encryption_password_url
    assert_response :success
  end

  test '#save, should save password in cookie' do
    patch encryption_save_url,
          params: { user: { password: '123456' } }

    assert_equal(cookies[:encryption_password], '123456')
  end
end
