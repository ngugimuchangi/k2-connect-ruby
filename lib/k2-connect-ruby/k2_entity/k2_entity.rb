class K2Entity
  attr_accessor :access_token,
                :the_array

  # Initialize with access token from Subscriber Class
  def initialize(access_token)
    @access_token = access_token
  end

  def self.hash_it(path_url, request, class_type, body)
    return {
        path_url: path_url,
        access_token:  @access_token,
        request_type: request,
        class_type: class_type,
        params: body
    }
  end

end