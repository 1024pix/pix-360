# frozen_string_literal: true

require 'test_helper'

class EncryptionControllerTest < ActionDispatch::IntegrationTest
  test 'should get password when user has sign in' do
    sign_in users(:two)
    get encryption_url
    assert_response :success
  end

  test '#save, should save password in cookie' do
    sign_in users(:two)
    patch encryption_save_url,
          params: { user: { password: '123456' } }

    assert_equal(cookies[:encryption_password], '123456')
  end

  test '#edit, should go to passwords edit when login' do
    sign_in users(:one)
    get encryption_edit_url
    assert_response :success
  end

  setup do
    @user = users(:one)
    @user.must_change_password = true
  end

  test '#edit, should update user password' do
    sign_in users(:one)
    patch encryption_update_url(@user),
          params: { user: { password: 'updated-password', password_confirmation: 'updated-password',
                            must_change_password: false } }

    assert_redirected_to home_private_url
    # Reload association to fetch updated data and assert that title is updated.
    @user.reload
    assert_equal false, @user.must_change_password
    assert_not_empty @user.private_key
    assert_not_empty @user.public_key
  end
end
