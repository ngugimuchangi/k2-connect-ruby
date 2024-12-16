require 'faker'

RSpec.describe K2ConnectRuby::K2Entity::K2Notification do
  before(:each) do
    stub_request(:post, 'https://sandbox.kopokopo.com/oauth/token').to_return(body: { access_token: "access_token" }.to_json, status: 200)
    @access_token = K2ConnectRuby::K2Entity::K2Token.new('client_id', 'client_secret').request_token
    @k2_notification = K2ConnectRuby::K2Entity::K2Notification.new(@access_token)
    stub_request(:post, /sandbox.kopokopo.com/).to_return(status: 201, body: {data: "some_data"}.to_json, headers: { location: Faker::Internet.url })
  end

  before(:all) do
    @sms_notification_payload = HashWithIndifferentAccess.new(webhook_event_reference: 'webhook_event_reference', message: 'message', callback_url: 'callback_url')
  end

  describe '#initialize' do
    it 'should initialize with access_token' do
      K2ConnectRuby::K2Entity::K2Notification.new('access_token')
    end

    it 'should raise an error when there is an empty access_token' do
      expect { K2ConnectRuby::K2Entity::K2Notification.new('') }.to raise_error ArgumentError
    end
  end

  describe '#send_sms_transaction_notification' do
    it 'should send an sms transaction notification request' do
      aggregate_failures do
        expect { @k2_notification.send_sms_transaction_notification(@sms_notification_payload) }.not_to(raise_error)
        expect(WebMock).to have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.path_url('transaction_sms_notifications'))
      end
    end

    it 'returns a location_url' do
      @k2_notification.send_sms_transaction_notification(@sms_notification_payload)
      expect(@k2_notification.location_url).not_to(eq(nil))
    end
  end

  describe '#query_resource' do
    before(:each) do
      @k2_notification.send_sms_transaction_notification(@sms_notification_payload)
      stub_request(:get, @k2_notification.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
    end

    it 'should query recent sms transaction notification request' do
      aggregate_failures do
        expect { @k2_notification.query_resource }.not_to(raise_error)
        expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2_notification.location_url)))
      end
    end

    it 'returns a response body' do
      @k2_notification.query_resource
      expect(@k2_notification.k2_response_body).not_to(eq(nil))
    end
  end

  describe '#query_resource_url' do
    before(:each) do
      @k2_notification.send_sms_transaction_notification(@sms_notification_payload)
      stub_request(:get, @k2_notification.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
    end

    it 'should query specific resource_url' do
      aggregate_failures do
        expect { @k2_notification.query_resource_url(@k2_notification.location_url) }.not_to(raise_error)
        expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2_notification.location_url)))
      end
    end

    it 'returns a response body' do
      @k2_notification.query_resource_url(@k2_notification.location_url)
      expect(@k2_notification.k2_response_body).not_to(eq(nil))
    end
  end
end
