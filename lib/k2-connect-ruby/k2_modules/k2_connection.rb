require 'net/http/persistent'
require 'json'
require 'yajl'
# Module for Sending the Requests
module K2Connect
  # Method for sending the request to K2 sandbox or Mock Server
  def self.connect(connection_hash)
    # Sandbox API host url
    # Sets the URL through the Config Module
    base_url ||= K2Config.base_url

    # Access Token
    access_token = connection_hash[:access_token]
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
      k2_uri = K2UrlParse.remove_localhost(URI.parse(path_url))
      k2_request = Net::HTTP::Get.new(k2_uri.path)
    when 'POST'
      k2_uri = URI.parse(base_url + '/' + path_url)
      k2_request = Net::HTTP::Post.new(k2_uri.path, 'Content-Type': 'application/json')
    else
      raise ArgumentError, 'Undefined Request Type'
    end

    unless path_url.eql?('oauth')
      k2_request.add_field('Accept', 'application/vnd.kopokopo.v1.hal+json')
      k2_request.add_field('Authorization', "Bearer #{access_token}")
    end
    k2_request.body = connection_hash[:params].to_json

    k2_https = Net::HTTP::Persistent.new
    k2_response = k2_https.request(k2_uri, k2_request)

    # Response Body
    response_body = Yajl::Parser.parse(k2_response.body)
    response_headers = Yajl::Parser.parse(k2_response.header.to_json)
    # Response Code TODO: Uncomment amd to be before response_body
    #response_code = k2_response.code.to_s
    #raise K2ConnectionError.new(response_code) && k2_https.shutdown unless response_code[0].eql?(2.to_s)

    unless request_type.eql?('GET')
      # puts "Response Header: #{response_headers}" unless class_type.eql?("Access Token") || response_headers.blank?
      # puts "Response Location URL: #{response_headers["location"][0]}" unless class_type.eql?("Access Token") || response_headers.blank?
      # Returns the access token for authorization
      return response_body['access_token'] if path_url.eql?('oauth/token')

      # Return the location url for POST Requests
      return response_headers["location"][0]
    end

    # Return the result of the Query
    #puts "Response Body: #{response_body}" unless response_body.blank?
    return response_body
  end
end
