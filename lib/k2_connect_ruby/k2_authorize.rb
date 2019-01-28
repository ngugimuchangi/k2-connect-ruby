module K2ConnectRuby
  class K2Authorize
    # Compares HMAC signature with the key. Later call it K2Authenticator
    def authenticate(body, api_secret_key, signature)
      nil_request body, api_secret_key, signature
      digest = OpenSSL::Digest.new('sha256')
      hmac = OpenSSL::HMAC.hexdigest(digest, api_secret_key, body.to_json)
      return ActiveSupport::SecurityUtils.secure_compare(hmac, signature)
    rescue Exception => e
      puts(e.message)
    end

    def nil_request x, y, z
      raise ArgumentError.new "Nil Request Body Argument!" if x.nil?
      raise ArgumentError.new "Nil Secret Key Argument!" if y.nil?
      raise ArgumentError.new "Nil Signature Argument!" if z.nil?
    end

  end
end