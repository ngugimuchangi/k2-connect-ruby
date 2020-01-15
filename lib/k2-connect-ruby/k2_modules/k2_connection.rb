require 'net/http/persistent'
require 'json'
require 'yajl'
# Module for Sending the Requests
module K2Connect
  # Method for sending the request to K2 sandbox or Mock Server
  def self.to_connect(connection_hash)
    # The Server. WONT BE HARD CODED.
    #host_url = 'https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io'
    # Sandbox API host url
    #host_url = 'http://127.0.0.1:3000'
    # Sets the URL through the Config Module
    host_url ||= K2Config.get_host_url

    # No access token given except for token_request in the Subscription class.
    # Access Token
    access_token = connection_hash[:access_token]
    # puts "The Access Token:\t#{access_token}"
    # Class type
    class_type = connection_hash[:class_type]
    # Path Url
    path_url = connection_hash[:path_url]
    # Request Type
    request_type = connection_hash[:request_type]

    unless class_type.eql?('Access Token') || access_token.present?
      raise ArgumentError, 'No Access Token in Arguments!'
    end

    case request_type
    when 'GET'
      k2_uri = URI.parse(path_url)
      k2_request = Net::HTTP::Get.new(k2_uri.path)
    when 'POST'
      k2_uri = URI.parse(host_url + '/' + path_url)
      k2_request = Net::HTTP::Post.new(k2_uri.path, 'Content-Type': 'application/json')
    else
      raise ArgumentError, 'Undefined Request Type'
    end

    unless path_url.eql?('oauth')
      k2_request.add_field('Accept', 'application/json')
      k2_request.add_field('Authorization', "Bearer #{access_token}")
    end
    k2_request.body = connection_hash[:params].to_json

    k2_https = Net::HTTP::Persistent.new
    k2_response = k2_https.request(k2_uri, k2_request)

    # Response Body
    response_body = Yajl::Parser.parse(k2_response.body)
    # Response Code
    response_code = k2_response.code.to_s

    raise K2ConnectionError.new(response_code) unless response_code[0].eql?(2.to_s)
    # If successful, add a method to fetch the components of the response
    return response_body['access_token'] if path_url.eql?('oauth/token')

    # For STK Push, PAY and Transfers
    unless class_type.eql?('Subscription')
      # Return the result of the Query
      return response_body if request_type.eql?('GET')

      # Return the location url for POST Requests
      return response_body['location']
    end

    k2_https.shutdown
  end
end
