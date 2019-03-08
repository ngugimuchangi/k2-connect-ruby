require 'net/http/persistent'
require 'json'
# Module for Sending the Requests
module K2Connect
  # Method for sending the request to K2 sandbox or Mock Server (Receives the access_token)
  def self.to_connect(connection_hash)
    # The Server. WONT BE HARD CODED.
    host_url = "https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io"
    host_url ||= K2Config.get_host_url

    # Raised in the scenario when there is no access token given except for token_request in the Subscription class.
    unless connection_hash[:class_type].eql?("Subscription") || connection_hash[:access_token].present?
      raise ArgumentError.new("No Access Token in Arguments!")
    end
    k2_url = URI.parse(host_url+"/"+connection_hash[:path_url])
    k2_https = Net::HTTP::Persistent.new
    case connection_hash[:request_type]
    when "GET"
      k2_request = Net::HTTP::Get.new(k2_url.path)
    when "POST"
      k2_request = Net::HTTP::Post.new(k2_url.path)
    else
      raise ArgumentError.new("Undefined Request Type")
    end
    k2_request.add_field('Content-Type', 'application/json')
    unless connection_hash[:path_url].eql?("ouath")
      k2_request.add_field('Accept', 'application/json')
      k2_request.add_field("Authorization", "Bearer #{connection_hash[:access_token]}")
    end
    k2_request.body = connection_hash[:params].to_json

    # k2_response = ""
    # threads = []
    # threads << Thread.new do
    #   sleep 0.5
    # end
    # threads.each {|conn| conn.join}
    k2_response = k2_https.request(k2_url, k2_request)


    # Add a method to fetch the components of the response
    if connection_hash[:path_url].eql?("ouath")
      return Yajl::Parser.parse(k2_response.body)["access_token"]
    else
      unless connection_hash[:class_type].eql?("Subscription")
        return Yajl::Parser.parse(k2_response.body)["location"]
      end
    end
    k2_https.shutdown
    return true
  end
end