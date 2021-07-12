module K2Connect
  # Method for sending the request to K2 sandbox or Mock Server
  def self.make_request(connection_hash)
    access_token = connection_hash[:access_token]
    class_type = connection_hash[:class_type]
    path_url = connection_hash[:path_url]
    request_type = connection_hash[:request_type]

    unless class_type.eql?('Access Token') || access_token.present?
      raise ArgumentError, 'No Access Token in Arguments!'
    end

    # Set up Headers
    headers = { 'Content-Type': 'application/json', Accept: 'application/json', Authorization: "Bearer #{access_token}" }
    # For access token request
    if path_url.include?('oauth/token/info')
      headers = { 'Content-Type': 'application/json', Accept: 'application/json', Authorization: "Bearer #{access_token}" }
    elsif path_url.include?('oauth/')
      headers = { 'Content-Type': 'application/json' }
    end

    k2_response = RestClient::Request.execute(method: request_type, url: path_url, headers: headers, payload: connection_hash[:params].to_json)

    # Response Body
    response_body = Yajl::Parser.parse(k2_response.body)
    response_headers = Yajl::Parser.parse(k2_response.headers.to_json)
    response_code = k2_response.code.to_s
    raise K2ConnectionError.new(response_code) unless response_code[0].eql?(2.to_s)

    unless request_type.eql?('get')
      # Returns the access token for authorization
      return response_body['access_token'] if path_url.include?('oauth/token')

      # Return the location url for post Requests
      return response_headers["location"]
    end

    # Return the result of the Query
    return response_body
  end
end
