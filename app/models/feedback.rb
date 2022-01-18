# frozen_string_literal: true

require('aes_256_gcm_encryption')
require('elliptic_curve')
require('bcrypt')

class Feedback < ApplicationRecord
  attr_accessor :decrypted_shared_key, :decrypted_content

  belongs_to :giver, class_name: 'User', optional: true, foreign_key: 'respondent_id', inverse_of: :given_feedbacks
  belongs_to :requester, class_name: 'User', inverse_of: :received_feedbacks

  def self.create_with_shared_key(encryption_password)
    f = Feedback.new
    keys = EllipticCurve.new
    shared_key = keys.shared_key(f.requester.public_key)
    f.decrypted_shared_key = shared_key
    f.shared_key = Aes256GcmEncryption.encrypt(shared_key, encryption_password)
    f.shared_key_hash = BCrypt::Password.create(shared_key)
    f.create_content
    f.save
    f
  end

  def create_content
    content = { 'positive_points': '', 'improve_areas': '', 'comments': '' }
    self.content = Aes256GcmEncryption.encrypt(content.to_json, decrypted_shared_key)
  end

  def decrypt_content
    decrypted_stringify_content = Aes256GcmEncryption.decrypt(content, decrypted_shared_key)
    self.decrypted_content = ActiveSupport::JSON.decode(decrypted_stringify_content).symbolize_keys
  end

  def decrypt_shared_key(encryption_password)
    self.decrypted_shared_key = Aes256GcmEncryption.decrypt(shared_key, encryption_password)
  end

  def update_content(feedback_params, respondent_id = nil)
    self.content = Aes256GcmEncryption.encrypt(feedback_params[:content].to_json,
                                               feedback_params[:decrypted_shared_key])
    self.respondent_id = respondent_id
    save
  end

  def verify_shared_key(shared_key_to_verify)
    BCrypt::Password.new(shared_key_hash) == shared_key_to_verify
  end

  def already_edit_by_user?
    !!respondent_id
  end

  def edited_by_user?(user_id)
    respondent_id == user_id
  end
end
