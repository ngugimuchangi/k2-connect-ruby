module SpecStubRequest
  def self.mock_stub_request(request_type, path_url, request_body, response_code, location_url=nil, response_body=nil)
    request_body = request_body.to_s
    response_body = response_body.to_s
    # Request
    request_uri = "http://127.0.0.1:3000/#{path_url}"
    request_headers = { Authorization: "Bearer access_token", Accept: "application/vnd.kopokopo.v1.hal+json" }
    if request_type.eql?('post')
      request_headers['Content-Type'] = 'application/json'
    end

    # Response
    response_headers = { 'X-Frame-Options': 'SAMEORIGIN', 'X-XSS-Protection': '1; mode=block', 'X-Content-Type-Options': 'nosniff', 'X-Download-Options': 'noopen',
      'X-Permitted-Cross-Domain-Policies': 'none', 'Referrer-Policy': 'strict-origin-when-cross-origin',
      'location': location_url, 'Content-Type': 'application/vnd.kopokopo.v1.hal+json',
      'Cache-Control': 'no-cache', 'X-Request-Id': '44236138-0ed1-40a5-929a-68d6652e0921', 'X-Runtime': '0.038577', 'Transfer-Encoding': 'chunked' }

    # Stub Request
    WebMock.stub_request(:"#{request_type}", request_uri)
        .with(headers: request_headers, body: request_body)
        .to_return(status: response_code, headers: response_headers, body: response_body)

    # Test URI connection
    test_uri = URI.parse(request_uri)
    test_request = Net::HTTP::Post.new(test_uri.path)

    # Headers
    test_request['Authorization'] = 'Bearer access_token'
    test_request['Accept'] = 'application/vnd.kopokopo.v1.hal+json'
    test_request['Content-Type'] = 'application/json'

    # Sending out request
    Net::HTTP.start(test_uri.host, test_uri.port) do |http|
      http.request(test_request, request_body)
    end
  end

  def subscription_stub_request(event_type, url)
    request_body = { event_type: event_type, url: 'https://myapplication.com/webhooks', secret: 'webhook_secret' }
    return_response = nil
    # pay_recipients stub method
    mock_stub_request('post', url, request_body, @subscription_headers,200, return_response)
  end
end