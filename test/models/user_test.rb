# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test '#create_encryption_keys : should create encryption_keys and save it' do
    @user.password = 'Pa$$word'

    @user.create_encryption_keys

    assert_not_empty @user.private_key
    assert_not_empty @user.public_key
  end

  test '#elliptic_curve: should return same elliptic curve instance than save' do
    @user.password = 'Pa$$word'
    @user.create_encryption_keys
    public_key = @user.public_key

    elliptic_curve = @user.elliptic_curve

    assert_equal public_key, elliptic_curve.public_key
  end

  test '#deprecate: should change email and google_id' do
    @user.deprecate

    assert_equal 'deleted_1_test1@example.net', @user.email
    assert_nil @user.google_id
  end
end
