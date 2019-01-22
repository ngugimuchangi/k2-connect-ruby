module K2ConnectRubyApiGem
  class Client
    def initialize(access_token = nil)
      @access_token = access_token || ENV["K2CONNECTRUBYAPIGEM_ACCESS_TOKEN"]
    end

    # This is the method for get parsing the json response
    def parse_it(req_body, req_headers)

      # With YAJL
      # json = File.open('/home/k2-engineering-03/RubymineProjects/k2_exported_JSON.json', 'r')
      hash_b = Yajl::Parser.parse(req_body)
      hash_h = Yajl::Parser.parse(req_headers)
      # The X-KopoKopo-Signature for test
      # comparison_signature="c839d24ff8a2ec26550d435cf69891347b63aae8"

      # hash_b.extend Hashie::Extensions::DeepFind
      hash_h.extend Hashie::Extensions::DeepFind
      authorize_it(hash_b.to_s, hash_h.deep_select("HTTP_X_KOPOKOPO_SIGNATURE").to_s)
      # puts ("\n\nThis is the Hash Body: \t #{hash}")
      # puts ("\n\nThis is the Hash Body: \t #{hash.deep_select("body")}")
    end

    # Method for comparing the HMAC and with HTTP_X_KOPOKOPO_SIGNATURE
    def authorize_it(message_body, comparison_signature)
      secret_key = "b647be91024bc03fb9e83f92238b973a4c070269"
      digest = OpenSSL::Digest.new('sha256')
      hmac = OpenSSL::HMAC.hexdigest(digest, secret_key, message_body)
      # puts("\n\n This is the trial HMAC hexdigest #{hmac}")
      puts("\n\nMessage Body: #{message_body}\n\nX-K2-Signature: #{JSON.parse(comparison_signature).join(', ')}\n\n The HMAC hash: #{hmac}")
      puts(hmac.to_s.eql?(JSON.parse(comparison_signature).join(', ')))
    end
  end
end