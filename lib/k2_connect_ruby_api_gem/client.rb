module K2ConnectRubyApiGem
  class Client
    @secret_key
    def initialize(secret_key)
      @secret_key = secret_key
    end

    # This is the method for get parsing the json response
    def parse_it(req_body, req_headers, req_status)

      # With YAJL
      hash_b = Yajl::Parser.parse(req_body)
      hash_h = Yajl::Parser.parse(req_headers)

      hash_h.extend Hashie::Extensions::DeepFind
      # if hash_b.deep_select("Method").eql?("POST")
      #   authorize_it(hash_b.to_s, hash_h.deep_select("HTTP_X_KOPOKOPO_SIGNATURE").to_s)
      #   # return req_status
      # else
      #   req_status = 500
      #   return req_status
      #   abort("Does not Work.")
      # end
      # authorize_it(hash_b.to_s, hash_h.deep_select("HTTP_X_KOPOKOPO_SIGNATURE").to_s)
    end

    # Method for comparing the HMAC and with HTTP_X_KOPOKOPO_SIGNATURE
    def authorize_it(message_body, comparison_signature)
      digest = OpenSSL::Digest.new('sha256')
      hmac = OpenSSL::HMAC.hexdigest(digest, @secret_key, message_body)
      puts("\n\nMessage Body: #{message_body}\n\nX-K2-Signature: #{JSON.parse(comparison_signature).join(', ')}\n\n The HMAC hash: #{hmac}")
      puts(hmac.to_s.eql?(JSON.parse(comparison_signature).join(', ')))
    end

    def parse_it_whole(the_res)
      hash_r = Yajl::Parser.parse(the_res)
      hash_r.extend Hashie::Extensions::DeepFind
      authorize_it(hash_r.deep_select("body").to_s, "2132313")
    end
  end
end