module SpecStubRequest
  def self.stub_request(request_type, path_url, request_body, response_code)
    request_body = request_body.to_s

    request_uri = "#{K2Config.base_url}/#{path_url}"
    request_headers = { Authorization: "Bearer access_token", Accept: "application/vnd.kopokopo.v1.hal+json" }

    if request_type.eql?('post')
      request_headers['Content-Type'] = 'application/json'
    end

    # Stub Request
    WebMock.stub_request(:"#{request_type}", request_uri)
        .with(headers: request_headers, body: request_body)
        .to_return(status: response_code)
  end

  def subscription_stub_request(event_type, url)
    request_body = { event_type: event_type, url: url, secret: 'webhook_secret' }
    # pay_recipients stub method
    SpecStubRequest.stub_request('post', K2Config.path_variable('webhook_subscriptions'), request_body, 200)
  end

end