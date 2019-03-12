require 'net/http/persistent'
require 'json'
require 'yajl'
# Module for Sending the Requests
module K2Connect
  # Method for sending the request to K2 sandbox or Mock Server
  def self.to_connect(connection_hash)
    # The Server. WONT BE HARD CODED.
    host_url = 'https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io'
    host_url ||= K2Config.get_host_url

    # No access token given except for token_request in the Subscription class.
    unless (c_type = connection_hash[:class_type].eql?('Subscription')) || (access_token = connection_hash[:access_token]).present?
      raise ArgumentError.new('No Access Token in Arguments!')
    end

    k2_uri = URI.parse(host_url + '/' + (path_url = connection_hash[:path_url]))
    k2_https = Net::HTTP::Persistent.new

    case connection_hash[:request_type]
    when 'GET'
      k2_request = Net::HTTP::Get.new(k2_uri.path)
    when 'POST'
      k2_request = Net::HTTP::Post.new(k2_uri.path, 'Content-Type': 'application/json')
    else
      raise ArgumentError.new('Undefined Request Type')
    end

    unless path_url.eql?('ouath')
      k2_request.add_field('Accept', 'application/json')
      k2_request.add_field('Authorization', "Bearer #{access_token}")
    end
    k2_request.body = connection_hash[:params].to_json

    k2_response = k2_https.request(k2_uri, k2_request)
    response_body = Yajl::Parser.parse(k2_response.body)
    response_code = k2_response.code.to_s

    raise K2ConnectionError.new(response_code) unless response_code[0].eql?(2.to_s)
    # If successful, add a method to fetch the components of the response
    return response_body['access_token'] if path_url.eql?('ouath')
    return response_body['location'] unless c_type.eql?('Subscription')

    k2_https.shutdown
  end
end
