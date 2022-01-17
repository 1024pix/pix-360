# frozen_string_literal: true

require('aes_256_gcm_encryption')
require('elliptic_curve')

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :given_feedbacks, class_name: 'Feedback',
                             foreign_key: 'respondent_id',
                             dependent: :destroy,
                             inverse_of: :giver
  has_many :received_feedbacks, class_name: 'Feedback',
                                foreign_key: 'requester_id',
                                dependent: :destroy,
                                inverse_of: :requester

  def self.from_google_oauth2(auth)
    where(google_id: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.must_change_password = true
    end
  end

  def create_encryption_keys
    keys = EllipticCurve.new
    self.public_key = keys.public_key
    self.private_key = Aes256GcmEncryption.encrypt(keys.private_key, password)
    save
  end

  def elliptic_curve
    decrypted_private_key = Aes256GcmEncryption.decrypt(private_key, password)
    EllipticCurve.new(decrypted_private_key)
  end
end
