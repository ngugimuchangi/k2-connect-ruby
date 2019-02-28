require 'openssl'

module K2Authenticator
  # Compares HMAC signature with the key.
  def self.authenticate?(body, api_secret_key, signature)
    raise K2EmptyAuthArgument if body.nil? || api_secret_key.nil? || signature.nil? && body=="" || api_secret_key=="" || signature==""
    digest = OpenSSL::Digest.new('sha256')
    hmac = OpenSSL::HMAC.hexdigest(digest, api_secret_key, body.to_json)
    if ActiveSupport::SecurityUtils.secure_compare(hmac, signature)
      return true
    else
      raise K2InvalidHMAC
    end
  rescue K2EmptyAuthArgument => k2
    return false
  rescue K2InvalidHMAC => k3
    return false
  rescue StandardError => e
    puts(e.message)
  end
end