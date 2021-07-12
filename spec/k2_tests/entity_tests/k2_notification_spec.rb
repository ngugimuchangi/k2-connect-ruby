include SpecConfig
RSpec.describe K2Notification do
  before(:all) do
    @access_token = K2AccessToken.new('T1RyrPntqO4PJ35RLv6IVfPKRyg6gVoMvXEwEBin9Cw', 'Ywk_J18RySqLOmhhhVm8fhh4FzJTUzVcZJ03ckNpZK8').request_token
    @k2_notification = K2Notification.new(@access_token)
    @sms_notification_payload = HashWithIndifferentAccess.new(webhook_event_reference: 'c271535c-687f-4a40-a589-8b66b894792e', message: 'Bankai', callback_url: 'https://webhook.site/48d6113c-8967-4bf4-ab56-dcf470e0b005')
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
    let(:bg){ webhook_structure('buygoods_transaction_received', 'till', 112233) }

    it 'should send an sms transaction notification request' do
      SpecConfig.custom_stub_request('post', K2Config.path_url('transaction_sms_notifications'), @sms_notification_payload, 201)
      expect { @k2_notification.send_sms_transaction_notification(@sms_notification_payload) }.not_to raise_error
      expect(WebMock).to have_requested(:post, K2Config.path_url('transaction_sms_notifications'))
    end

    it 'returns a location_url' do
      @k2_notification.send_sms_transaction_notification(@sms_notification_payload)
      expect(@k2_notification.location_url).not_to eq(nil)
    end
  end

  describe '#query_resource' do
    it 'should query recent sms transaction notification request' do
      SpecConfig.custom_stub_request('get', @k2_notification.location_url, '', 200)
      expect { @k2_notification.query_resource }.not_to raise_error
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2_notification.location_url)))
    end

    it 'returns a response body' do
      @k2_notification.query_resource
      expect(@k2_notification.k2_response_body).not_to eq(nil)
    end
  end

  describe '#query_resource_url' do
    it 'should query specific resource_url' do
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
