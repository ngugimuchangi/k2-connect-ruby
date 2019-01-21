module K2ConnectRubyApiGem
  class Client
    def initialize(access_token = nil)
      @access_token = access_token || ENV["K2CONNECTRUBYAPIGEM_ACCESS_TOKEN"]
    end

    # This is the method for get parsing the json response
    def parse_it()

      # With YAJL
      json = File.open('/home/k2-engineering-03/RubymineProjects/k2_exported_JSON.json', 'r')
      parser = Yajl::Parser.new
      hash = parser.parse(json)

      # The X-KopoKopo-Signature for test
      # comparison_signature="c839d24ff8a2ec26550d435cf69891347b63aae8"

      hash.extend Hashie::Extensions::DeepFind
      authorize_it(hash.deep_select("resourceId").to_s, hash.deep_select("X-KopoKopo-Signature").to_s)
      # puts ("\n\nThis is the Hash Body: \t #{hash}")
      # L8r change this to be X-KopoKopo-Signature
      # puts ("\n\nThis is the Hash Body: \t #{hash.deep_select("body")}")

    end

    def authorize_it(message_body, comparison_signature)
      secret_key = "b647be91024bc03fb9e83f92238b973a4c070269"
      digest = OpenSSL::Digest.new('sha1')
      hmac = OpenSSL::HMAC.hexdigest(digest, secret_key, message_body)
      # puts("\n\n This is the trial HMAC hexdigest #{hmac}")
      puts("\n\n Message resourceId: #{message_body} \n\nX-K2-Signature: #{comparison_signature}")
      puts(hmac.eql?(comparison_signature))
    end
  end
end