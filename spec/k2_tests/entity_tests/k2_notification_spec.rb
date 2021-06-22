include SpecConfig
RSpec.describe K2Subscribe do
  before(:all) do
    @access_token = K2AccessToken.new('_9fXMGROLmSegBhofF6z-qDKHH5L6FsbMn2MgG24Xnk', 'nom1cCNLeFkVc4qafcBu2bGqGWTKv9WgS8YvZR3yaq8').request_token
    @k2_notification = K2Notification.new(@access_token)
    @sms_notification_payload = HashWithIndifferentAccess.new(webhook_event_reference: 'ruby_sdk_webhook_event_reference', message: 'Hello there', callback_url: 'https://webhook.site/48d6113c-8967-4bf4-ab56-dcf470e0b005')
  end

  describe '#initialize' do
    it 'should initialize with access_token' do
      K2Notification.new('access_token')
    end

    it 'should raise an error when there is an empty access_token' do
      expect { K2Notification.new('') }.to raise_error ArgumentError
    end
  end

  describe '#send_sms_transaction_notification' do
    it 'should send an sms transaction notification request' do
      SpecConfig.custom_stub_request('post', K2Config.path_url('transaction_sms_notifications'), @sms_notification_payload, 201)
      expect { @k2_notification.send_sms_transaction_notification(@sms_notification_payload) }.not_to raise_error
      expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
    end

    it 'returns a location_url' do
      @k2_notification.send_sms_transaction_notification(@sms_notification_payload)
      expect(@k2_notification.location_url).not_to eq(nil)
    end
  end

  describe '#query_resource' do
    it 'should query recent webhook subscription' do
      SpecConfig.custom_stub_request('get', @k2_notification.location_url, '', 200)
      expect { @k2_notification.query_webhook }.not_to raise_error
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2_notification.location_url)))
    end

    it 'returns a response body' do
      @k2_notification.query_webhook
      expect(@k2_notification.k2_response_body).not_to eq(nil)
    end
  end

  describe '#query_resource_url' do
    it 'should query recent webhook subscription' do
      SpecConfig.custom_stub_request('get', @k2_notification.location_url, '', 200)
      expect { @k2_notification.query_resource_url(@k2_notification.location_url) }.not_to raise_error
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2_notification.location_url)))
    end

    it 'returns a response body' do
      @k2_notification.query_resource_url(@k2_notification.location_url)
      expect(@k2_notification.k2_response_body).not_to eq(nil)
    end
  end
end
