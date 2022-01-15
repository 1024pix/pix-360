# frozen_string_literal: true

require('aes_256_gcm_encryption')
require('elliptic_curve')
require('bcrypt')

class Feedback < ApplicationRecord
  belongs_to :giver, class_name: 'User', optional: true, foreign_key: 'respondent_id', inverse_of: :given_feedbacks
  belongs_to :requester, class_name: 'User', inverse_of: :received_feedbacks

  def self.create_with_shared_key(encryption_password)
    f = Feedback.new
    keys = EllipticCurve.new
    shared_key = keys.shared_key(f.requester.public_key)
    f.shared_key = Aes256GcmEncryption.encrypt(shared_key, encryption_password)
    f.shared_key_hash = BCrypt::Password.create(shared_key)
    f.save
    f
  end

  def decrypted_shared_key(encryption_password)
    Aes256GcmEncryption.decrypt(shared_key, encryption_password)
  end
end
