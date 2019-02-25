class K2Entity
  attr_accessor :k2_access_token,
                :the_array

  # Initialize with access token from Subscriber Class
  def initialize(access_token)
    @k2_access_token = access_token
  end

end