module SpecConfig
  TILL_SCOPE_EVENT_TYPES = %[buygoods_transaction_received b2b_transaction_received buygoods_transaction_reversed]

  @specs = YAML.load_file(File.join('lib', 'k2-connect-ruby', 'k2_utilities', 'spec_modules', 'test_config.yml')).with_indifferent_access

  def subscription_stub_request(event_type, url)
    request_body = { event_type: event_type, url: url, secret: 'webhook_secret' }
    SpecConfig.custom_stub_request('post', K2Config.path_url('webhook_subscriptions'), request_body, 200)
  end

  def webhook_structure(event_type, scope, scope_reference = nil)
    {
        event_type: event_type,
        url: @callback_url,
        scope: scope,
        scope_reference: scope_reference,
    }
  end

  class << self
    def callback_url(context)
      @specs[:callback_url][:"#{context}"]
    end

    def custom_stub_request(request_type, path_url, request_body, response_code)
      request_body = request_body.to_s
      request_uri = path_url
      request_headers = { Authorization: "Bearer access_token", Accept: "application/json" }

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