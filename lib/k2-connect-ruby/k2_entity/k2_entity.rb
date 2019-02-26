class K2Entity
  attr_accessor :access_token,
                :the_array

  # Initialize with access token from Subscriber Class
  def initialize(access_token)
    @access_token = access_token
  end

end