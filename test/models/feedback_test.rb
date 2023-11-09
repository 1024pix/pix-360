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

  class UpdateContent < FeedbackTest
    setup do
      @user = users(:two)
      @user.password = 'azerty123'
      @user.create_encryption_keys
    end

    test 'it should merge content' do
      feedback = @user.received_feedbacks.create_with_shared_key({ email: 'foo@example.net' }, 'toto123')
      decrypted_shared_key = Aes256GcmEncryption.decrypt(feedback.shared_key, 'toto123')
      feedback_params = { decrypted_shared_key: decrypted_shared_key,
                          content: { answers: ['ma super réponse'] } }

      feedback.update_content feedback_params

      assert_not_empty feedback.decrypted_content[:questions]
      assert_not_empty feedback.decrypted_content[:answers]
    end

    test 'it should merge content with new_shared_key' do
      feedback = @user.received_feedbacks.create_with_shared_key({ email: 'foo@example.net' }, 'toto123')
      decrypted_shared_key = Aes256GcmEncryption.decrypt(feedback.shared_key, 'toto123')
      new_decrypted_shared_key = 'foo'
      feedback_params = { decrypted_shared_key: decrypted_shared_key,
                          new_decrypted_shared_key: new_decrypted_shared_key,
                          content: { answers: ['ma super réponse'] } }

      feedback.update_content feedback_params

      edited_feedback = Feedback.find(feedback.id)
      edited_feedback.decrypted_shared_key = new_decrypted_shared_key
      edited_feedback.decrypt_content

      assert_not_empty edited_feedback.decrypted_content[:questions]
      assert_not_empty edited_feedback.decrypted_content[:answers]
    end
  end
end
