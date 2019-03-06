require "yajl"

class K2Client
  attr_writer :api_secret_key,
                :hash_body,
                :hash_header,
                :k2_signature

  # Initialize method
  def initialize(api_secret_key)
    raise ArgumentError.new("No Secret Key Given!") if api_secret_key.blank?
    @api_secret_key = api_secret_key
  end

  # Method for parsing the Entire Request. Come back to it later to trim. L8r call it set_client_variables
  def parse_request(the_request)
    raise ArgumentError.new("Nil Request Parameter Input!") if the_request.blank?
    # The Response Body.
    @hash_body = Yajl::Parser.parse(the_request.body.string.as_json)
    # The Response Header
    @hash_header = Yajl::Parser.parse(the_request.headers.env.select{|k, _| k =~ /^HTTP_/}.to_json)
    # The K2 Signature
    @k2_signature = @hash_header["HTTP_X_KOPOKOPO_SIGNATURE"]
    # if the_request.scheme.eql?("https")
    #   # The Response Body.
    #   @hash_body = Yajl::Parser.parse(the_request.body.string.as_json)
    #   # The Response Header
    #   @hash_header = Yajl::Parser.parse(the_request.headers.env.select{|k, _| k =~ /^HTTP_/}.to_json)
    #   # The K2 Signature
    #   @k2_signature = @hash_header["HTTP_X_KOPOKOPO_SIGNATURE"]
    # else
    #   raise K2InsecureRequest.new
    # end
  end
end