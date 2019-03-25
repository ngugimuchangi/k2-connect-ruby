require 'openssl'
require 'active_support/security_utils'
# Module for Authenticating the Kopo Kopo Signature via HMAC
module K2Authenticator
  # Compares HMAC signature with the key.
  def self.authenticate(body, api_secret_key, signature)
    raise ArgumentError, "Nil Authentication Argument!\n Check whether your Input is Empty" if body.blank? || api_secret_key.blank? || signature.blank?

    digest = OpenSSL::Digest.new('sha256')
    hmac = OpenSSL::HMAC.hexdigest(digest, api_secret_key, body.to_json)
    raise ArgumentError, "Invalid Details Given!\n Ensure that your the Arguments Given are correct, namely:\n\t- The Response Body\n\t- Secret Key\n\t- Signature" unless ActiveSupport::SecurityUtils.secure_compare(hmac, signature)

    true
  end
end
