# Common Class Behaviours for stk, pay and transfers
class K2Entity
  attr_accessor :access_token, :the_array
  attr_reader :k2_response_body, :query_hash, :location_url
  include K2Validation

  # Initialize with access token from Subscriber Class
  def initialize(access_token)
    @access_token = access_token
    @threads = []
    @exception_array = %w[authenticity_token]
  end

  # Create a Hash containing important details accessible for K2Connect
  def self.make_hash(path_url, request, access_token, class_type, body)
    {
      path_url: path_url,
      access_token: access_token,
      request_type: request,
      class_type: class_type,
      params: body
    }.with_indifferent_access
  end

  # Query/Check the status of a previously initiated request
  def query_status(path_url, class_type)
    path_url = validate_url(path_url)
    query_hash = K2Pay.make_hash(path_url, 'GET', @access_token, class_type, nil)
    @threads << Thread.new do
      sleep 0.25
      @k2_response_body = K2Connect.connect(query_hash)
    end
    @threads.each(&:join)
  end
end
