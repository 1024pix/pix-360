# frozen_string_literal: true

require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
  class CreateWithSharedKey < FeedbackTest
    setup do
      @user = users(:two)
      @user.password = 'azerty123'
      @user.create_encryption_keys
    end

    test 'should create feedback from user and create shared_key' do
      feedback = @user.received_feedbacks.create_with_shared_key({ email: 'foo@example.net' }, 'toto123')
      assert_not_empty feedback.shared_key
      assert_not_empty feedback.shared_key_hash

      decrypted_shared_key = Aes256GcmEncryption.decrypt(feedback.shared_key, 'toto123')
      assert BCrypt::Password.new(feedback.shared_key_hash) == decrypted_shared_key
    end
  end
end
