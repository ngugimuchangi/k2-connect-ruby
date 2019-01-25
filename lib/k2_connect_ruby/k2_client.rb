module K2ConnectRuby
  class K2Client
    attr_accessor :api_secret_key, :hash_body, :hash_header, :client_id, :client_credentials, :token_object, :k2_signature
    # Intialize method
    def initialize(api_secret_key)
      @api_secret_key = api_secret_key
    end
    # Method for parsing the Entire Request. Come back to it later to trim. L8r call it set_client_variables
    def authorize_client(the_request)
      # The Response Body
      @hash_body = Yajl::Parser.parse(the_request.body.string.to_json)
      # The Response Header
      @hash_header = Yajl::Parser.parse(request.headers.env.select{|k, _| k =~ /^HTTP_/}.to_json)
      # The K2 Signature
      @k2_signature = @hash_header["HTTP_X_KOPOKOPO_SIGNATURE"]
    end
  end
end