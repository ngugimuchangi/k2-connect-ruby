module K2ConnectRuby
# attr_accessor :truth

  # Compares HMAC signature with the key
  class K2Authorize
    def authenticate(body, api_secret_key, signature)
      digest = OpenSSL::Digest.new('sha256')
      hmac = OpenSSL::HMAC.hexdigest(digest, api_secret_key, body)
      # @truth = secure_compare(hmac, signature)
      # @truth = hmac.to_s.eql?(signature)
      return secure_compare(hmac, signature)
    end
  end
end