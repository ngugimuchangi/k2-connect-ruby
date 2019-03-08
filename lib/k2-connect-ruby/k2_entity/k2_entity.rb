class K2Entity
  attr_accessor :access_token, :the_array
  attr_writer :query_hash

  # Initialize with access token from Subscriber Class
  def initialize(access_token)
    @access_token = access_token
    @threads = []
  end

  # Create a Hash containing important details accessible for K2Connect
  def self.make_hash(path_url, request, access_token, class_type, body)
    return {
        path_url: path_url,
        access_token: access_token,
        request_type: request,
        class_type: class_type,
        params: body
    }
  end

  # Query/Check the status of a previously initiated request
  def query_status(params, path_url, class_type)
    # Validation
    if validate_input(params, %w{ id })
      query_body = {
          ID: params.permit!.to_hash.select{|k| k.to_s.include?("id")}.each {|i| i}
      }
      query_hash = K2Pay.make_hash(path_url, "GET", @access_token, class_type, query_body)
      @threads << Thread.new do
        sleep 0.25
        K2Connect.to_connect(query_hash)
      end
      @threads.each {|t| t.join}
    end
  end

end