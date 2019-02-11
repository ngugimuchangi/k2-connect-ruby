module K2ConnectRuby
  class K2Client
    attr_accessor :api_secret_key,
                  :hash_body,
                  :hash_body_as,
                  :hash_header,
                  :client_id,
                  :token_object,
                  :k2_signature,
                  :access_token

    # Initialize method
    def initialize(api_secret_key)
      raise K2NilSecretKey.new if api_secret_key.nil?
      @api_secret_key = api_secret_key
    rescue K2NilSecretKey => k2
      puts(k2.message)
    rescue StandardError => e
      puts(e.message)
    end

    # Method for parsing the Entire Request. Come back to it later to trim. L8r call it set_client_variables
    def parse_request(the_request)
      raise K2NilRequest.new if the_request.nil?
      # The Response Body.
      @hash_body = Yajl::Parser.parse(the_request.body.string.as_json)
      # The Response Header
      @hash_header = Yajl::Parser.parse(the_request.headers.env.select{|k, _| k =~ /^HTTP_/}.to_json)
      # The K2 Signature
      @k2_signature = @hash_header["HTTP_X_KOPOKOPO_SIGNATURE"]
    rescue K2NilRequest => k2
      puts(k2.message)
    rescue StandardError => e
      puts(e.message)
    end
  end
end