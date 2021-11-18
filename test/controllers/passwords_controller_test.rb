# frozen_string_literal: true

require 'test_helper'

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'should go to passwords edit when login' do
    get passwords_edit_url
    assert_response :success
  end

  setup do
    @user = users(:one)
    @user.must_change_password = true
  end

  test 'should update user password' do
    patch passwords_update_url(@user),
          params: { user: { password: 'updated-password', password_confirmation: 'updated-password',
                            must_change_password: false } }

    assert_redirected_to home_private_url
    # Reload association to fetch updated data and assert that title is updated.
    @user.reload
    assert_equal false, @user.must_change_password
  end
end
