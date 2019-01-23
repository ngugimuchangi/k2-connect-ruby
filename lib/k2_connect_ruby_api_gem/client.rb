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
      # The Response Body
      hash_body = Yajl::Parser.parse(the_res.request.body.string.to_json)
      # The Response Header
      hash_header = Yajl::Parser.parse(the_res.request.headers.env.select{|k, _| k =~ /^HTTP_/}.to_json)
      hash_header.extend Hashie::Extensions::DeepFind
      # puts ("The Response without JSON: #{the_res}\n\n The Response with an attempted Hash #{hash_r}")
      authorize_it(hash_body.to_s, hash_header.deep_select("HTTP_X_KOPOKOPO_SIGNATURE").to_s)
    end
  end
end