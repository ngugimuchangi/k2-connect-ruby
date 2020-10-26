module SpecConfig
  @specs = YAML.load_file(File.join('lib', 'k2-connect-ruby', 'k2_utilities', 'spec_modules', 'test_config.yml')).with_indifferent_access

  def subscription_stub_request(event_type, url)
    request_body = { event_type: event_type, url: url, secret: 'webhook_secret' }
    # pay_recipients stub method
    SpecConfig.custom_stub_request('post', K2Config.path_url('webhook_subscriptions'), request_body, 200)
  end

  def webhook_structure(event_type)
    {
        event_type: event_type,
        url: @callback_url,
        scope: 'Till',
        scope_reference: '5555'
    }
  end

  class << self
    def callback_url(context)
      @specs[:callback_url][:"#{context}"]
    end

    def custom_stub_request(request_type, path_url, request_body, response_code)
      request_body = request_body.to_s
      request_uri = path_url
      request_headers = { Authorization: "Bearer access_token", Accept: "application/vnd.kopokopo.v1.hal+json" }

      if request_type.eql?('post')
        request_headers['Content-Type'] = 'application/json'
      end

      # Stub Request
      WebMock.stub_request(:"#{request_type}", request_uri)
          .with(headers: request_headers, body: request_body)
          .to_return(status: response_code)
    end
  end

end