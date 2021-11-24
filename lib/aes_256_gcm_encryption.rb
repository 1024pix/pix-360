# frozen_string_literal: true

require('base64')
require('openssl')

module Aes256GcmEncryption
  CIPHER_TYPE = 'AES-256-GCM'

  def self.derive_key(password, salt)
    iter = 100_000
    key_len = 32
    OpenSSL::KDF.pbkdf2_hmac(password, salt: salt, iterations: iter, length: key_len, hash: 'sha512')
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def self.decrypt(encrypted_data, password)
    base64_decoded = Base64.decode64(encrypted_data)
    salt = base64_decoded[0..63]
    iv = base64_decoded[64..75]
    tag = base64_decoded[76..91]
    data = base64_decoded[92..]

    cipher = OpenSSL::Cipher::Cipher.new(Aes256GcmEncryption::CIPHER_TYPE).decrypt
    cipher.key = derive_key(password, salt)
    cipher.iv = iv
    cipher.auth_tag = tag
    cipher.auth_data = ''

    cipher.update(data) + cipher.final
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/AbcSize
  def self.encrypt(data, password)
    salt = OpenSSL::Random.random_bytes(64)

    cipher = OpenSSL::Cipher::Cipher.new(Aes256GcmEncryption::CIPHER_TYPE).encrypt
    cipher.key = derive_key(password, salt)
    iv = cipher.random_iv
    cipher.iv = iv
    cipher.auth_data = ''
    encrypted = cipher.update(data) + cipher.final
    tag = cipher.auth_tag

    Base64.encode64(salt + iv + tag + encrypted)
  end
  # rubocop:enable Metrics/AbcSize
end
