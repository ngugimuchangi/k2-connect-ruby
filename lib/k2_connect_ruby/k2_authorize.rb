module K2ConnectRuby
  class K2Authorize
    # Compares HMAC signature with the key. Later call it K2Authenticator
    def authenticate?(body, api_secret_key, signature)
      raise K2Errors::K2NilAuthArgument if body.nil? || api_secret_key.nil? || signature.nil?
      digest = OpenSSL::Digest.new('sha256')
      hmac = OpenSSL::HMAC.hexdigest(digest, api_secret_key, body.to_json)
      return ActiveSupport::SecurityUtils.secure_compare(hmac, signature)
    rescue Exception => e
      puts(e.message)
    end
  end
end