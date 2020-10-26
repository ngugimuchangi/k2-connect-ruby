# TODO: Uncomment the checking of the request scheme
class K2Client
  attr_accessor :api_secret_key,
                :hash_body,
                :k2_signature

  # Initialize method
  def initialize(api_secret_key)
    raise ArgumentError, 'No Secret Key Given!' if api_secret_key.blank?
    @api_secret_key = api_secret_key
  end

  # Method for parsing the Entire Request. Come back to it later to trim. L8r call it set_client_variables
  def parse_request(the_request)
    raise ArgumentError, 'Nil Request Parameter Input!' if the_request.blank?

    # The Response Body.
    @hash_body = Yajl::Parser.parse(the_request.body.read.as_json)
    # The Response Header
    hash_header = Yajl::Parser.parse(the_request.env.select { |k, _| k =~ /^HTTP_/ }.to_json)
    # The K2 Signature
    @k2_signature = hash_header['HTTP_X_KOPOKOPO_SIGNATURE']
    # Authenticating the signature
    # K2Authenticator.authenticate(@hash_body, @api_secret_key, @k2_signature)
    # if the_request.scheme.eql?("https")
    # else
    #   raise K2InsecureRequest.new
    # end
  end
end
