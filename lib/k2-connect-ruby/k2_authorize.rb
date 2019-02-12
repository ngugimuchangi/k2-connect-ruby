module K2ConnectRuby
  class K2Authenticator
    # Compares HMAC signature with the key. Later call it K2Authenticator
    def authenticate?(body, api_secret_key, signature)
      if body.nil? # || api_secret_key.nil? || signature.nil?
        raise K2NilAuthArgument
      end
      digest = OpenSSL::Digest.new('sha256')
      hmac = OpenSSL::HMAC.hexdigest(digest, api_secret_key, body.to_json)
      return ActiveSupport::SecurityUtils.secure_compare(hmac, signature)
    rescue K2NilAuthArgument => k2
      puts(k2.message)
    rescue StandardError => e
      puts(e.message)
    end
  end
end