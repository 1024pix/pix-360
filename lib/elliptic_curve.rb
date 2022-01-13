# frozen_string_literal: true

require('openssl')

class EllipticCurve
  METHOD = 'secp521r1'

  def initialize
    @keys = OpenSSL::PKey::EC.generate(METHOD)
  end

  def shared_key(public_key_string)
    group = OpenSSL::PKey::EC::Group.new(METHOD)
    public_key_point = OpenSSL::PKey::EC::Point.new(group, OpenSSL::BN.new(public_key_string))
    Base64.encode64 @keys.dh_compute_key(public_key_point)
  end

  def public_key
    @keys.public_key.to_bn.to_s
  end

  def private_key
    @keys.to_pem
  end
end
