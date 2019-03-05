require 'net/http/persistent'
require 'json'
# Module for Sending the Requests
module K2Connect
  # Method for sending the request to K2 sandbox or Mock Server (Receives the access_token)
  def self.to_connect(connection_hash)
    # The Server. WONT BE HARD CODED.
    host_url = "https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io"

    # Raised in the scenario that when requests for an access_token even though they already have one. Change empty to blank for the rails app.
    unless connection_hash[:path_url].eql?("ouath")
      if connection_hash[:access_token].empty?
        raise ArgumentError.new("No Access Token in Argument!")
      end
    end
    k2_url = URI.parse(host_url+"/"+connection_hash[:path_url])
    k2_https = Net::HTTP::Persistent.new
    if connection_hash[:request_type].eql?("GET")
      k2_request = k2_https.request(Net::HTTP::Get.new(k2_url.request_uri))
    elsif connection_hash[:request_type].eql?("POST")
      k2_request = Net::HTTP::Post.new(k2_url.path)
    else
      puts "Undefined Request"
    end
    if connection_hash[:path_url].eql?("ouath")
      k2_request.add_field('Content-Type', 'application/json')
    else
      k2_request.add_field('Content-Type', 'application/json')
      k2_request.add_field('Accept', 'application/json')
      k2_request.add_field("Authorization", "Bearer #{connection_hash[:access_token]}")
    end
    k2_request.body = connection_hash[:params].to_json

    begin
      if connection_hash[:request_type].match?("GET")
        k2_response = k2_https.request(k2_request)
      elsif connection_hash[:request_type].match?("POST")
        k2_response = k2_https.request(k2_url, k2_request)
      else
        puts "Undefined Request Response"
      end
    rescue Net::HTTP::Persistent::Error => e
      puts(e.message)
    rescue Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse,
        Errno::EHOSTUNREACH, Net::ProtocolError, Net::OpenTimeout, Net::HTTPFatalError,
        Net::HTTPHeaderSyntaxError, Net::HTTPServerException, OpenSSL::SSL::SSLError,
        Net::HTTPRetriableError => he
      puts(he.message)
    end

    puts("\nThe Response:\t#{k2_response.body.to_s}")
    # Add a method to fetch the components of the response
    if connection_hash[:path_url].eql?("ouath")
      puts("\nThe Access Token:\t#{Yajl::Parser.parse(k2_response.body)["access_token"]}")
      return Yajl::Parser.parse(k2_response.body)["access_token"]
    else
      unless connection_hash[:class_type].eql?("Subscription")
        puts("\nThe Location Url:\t#{Yajl::Parser.parse(k2_response.body)["location"]}")
        return Yajl::Parser.parse(k2_response.body)["location"]
      end
    end
    k2_https.shutdown
    return true
  end
end