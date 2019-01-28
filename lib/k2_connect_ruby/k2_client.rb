module K2ConnectRuby
  class K2Client
    attr_accessor :api_secret_key,
                  :hash_body,
                  :hash_body_as,
                  :hash_header,
                  :client_id,
                  :client_credentials,
                  :token_object,
                  :k2_signature
    # Intialize method
    def initialize(api_secret_key)
      @api_secret_key = api_secret_key
    end

    # Method for parsing the Entire Request. Come back to it later to trim. L8r call it set_client_variables
    def parse_request(the_request)
      # The Response Body.
      @hash_body = Yajl::Parser.parse(the_request.body.string.as_json)
      # The Response Header
      @hash_header = Yajl::Parser.parse(the_request.headers.env.select{|k, _| k =~ /^HTTP_/}.to_json)
      # The K2 Signature
      @k2_signature = @hash_header["HTTP_X_KOPOKOPO_SIGNATURE"]
      # puts("\n\n#{the_request}\nHash Body:\t#{@hash_body}\nSignature:\t#{@k2_signature}")
    end
  end
end