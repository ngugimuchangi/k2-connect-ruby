require 'net/http/persistent'

module K2Connect
  # Method for sending the request to K2 sandbox or Mock Server (Receives the access_token)
  def K2Connect.to_connect(connection_hash)
    # The Server
    @postman_k2_mock_server = "https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io"

    # The HTTP Exceptions
    http_exceptions = [ Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse,
                        Errno::EHOSTUNREACH, Net::ProtocolError, Net::OpenTimeout, Net::HTTPFatalError,
                        Net::HTTPHeaderSyntaxError, Net::HTTPServerException, OpenSSL::SSL::SSLError,
                        Net::HTTPRetriableError ]

    # Raised in the scenario that when requests for an access_token even though they already have one
    if connection_hash[:path_url].match?("ouath")
      raise K2RepeatTokenRequest.new unless @access_token.nil?
    else
      raise K2NilAccessToken.new if connection_hash[:access_token].nil?
    end
    k2_url = URI.parse(@postman_k2_mock_server+"/"+connection_hash[:path_url])
    k2_https = Net::HTTP::Persistent.new
    if connection_hash[:is_get_request]
      k2_request = k2_https.request(Net::HTTP::Get.new(k2_url.request_uri))
    else
      k2_request = Net::HTTP::Post.new(k2_url.path)
    end
    if connection_hash[:path_url].match?("ouath")
      k2_request.add_field('Content-Type', 'application/json')
    else
      k2_request.add_field('Content-Type', 'application/json')
      k2_request.add_field('Accept', 'application/json')
      k2_request.add_field("Authorization", "Bearer #{connection_hash[:access_token]}")
    end
    k2_request.body = connection_hash[:params].to_json

    begin
      if connection_hash[:is_get_request]
        @k2_response = k2_https.request(k2_request)
      else
        @k2_response = k2_https.request(k2_url, k2_request)
      end
    rescue Net::HTTP::Persistent::Error => e
      puts(e.message)
    rescue http_exceptions => he
      puts(he.message)
    rescue K2RepeatTokenRequest => k2
      puts(k2.message)
    rescue K2NilAccessToken => k3
      puts(k3.message)
    rescue StandardError => se
      puts(se.message)
      return false
    end

    puts("\nThe Response:\t#{@k2_response.body.to_s}")
    # Add a method to fetch the components of the response
    if connection_hash[:path_url].match?("ouath")
      @access_token = Yajl::Parser.parse(@k2_response.body)["access_token"]
      puts("\nThe Access Token:\t#{@access_token}")
      return @access_token
    else
      unless connection_hash[:is_subscribe]
        @location = Yajl::Parser.parse(@k2_response.body)["location"]
        puts("\nThe Location Url:\t#{@location}")
      end
    end
    k2_https.shutdown
    return true
  end
end