# frozen_string_literal: true

require 'test_helper'

class FeedbacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:two)
    sign_in @user
    @user.password = '123456'
    @user.create_encryption_keys
    patch encryption_save_url,
          params: { user: { password: '123456' } }
  end

  class Index < FeedbacksControllerTest
    test 'should get index' do
      get feedbacks_url
      assert_response :success
    end
  end

  class Create < FeedbacksControllerTest
    test 'should create feedback with shared_key' do
      post feedbacks_url,
           params: { feedback: {} }

      assert_response :redirect
      assert_not_empty @user.received_feedbacks
      assert_not_empty @user.received_feedbacks[0].shared_key
    end
  end
end
