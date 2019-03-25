module SpecStubRequest
  def mock_stub_request(request_type, url, body, headers = nil, response_code, response_body)
    if request_type.eql?('get')
      headers ||= { 'Accept': %w(*/* application/json), 'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization': 'Bearer access_token',
                  'Connection': 'keep-alive', 'Keep-Alive': '30', 'User-Agent': 'Ruby' }
    elsif request_type.eql?('post')
      headers ||= { 'Accept': %w(*/* application/json), 'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization': 'Bearer access_token',
                  'Connection': 'keep-alive', 'Content-Type': 'application/json', 'Keep-Alive': '30', 'User-Agent': 'Ruby' }
    end
    stub_request(:"#{request_type}", "https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/#{url}")
        .with(body: body, headers: headers).
        to_return(status: response_code, body: response_body.to_json, headers: {})
  end

  def failed_stub_request(response_code)
    stub_request(:post, "https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/oauth").to_return(status: response_code)
  end

  def subscription_stub_request(event_type, url)
    request_body = { event_type: event_type, url: 'https://myapplication.com/webhooks', secret: 'webhook_secret' }
    return_response = nil
    # pay_recipients stub method
    mock_stub_request('post', url, request_body, @subscription_headers,200, return_response)
  end
end