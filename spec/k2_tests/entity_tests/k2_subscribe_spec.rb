include SpecConfig
RSpec.describe K2Subscribe do
  before(:all) do
    @access_token = K2AccessToken.new('KkcZEdj7qx7qfcFMyTWFaUXV7xZv8z8WIm72U06BiPI', 'mVoTlmrjsMw2mnfTXQrynz49ZcDX05Xp5wty-uNaZX8').request_token
    @k2subscriber = K2Subscribe.new(@access_token)
    @k2sub_not_exist = K2Subscribe.new(@access_token)
    @callback_url = SpecConfig.callback_url('webhook')
  end

  describe '#initialize' do
    it 'should initialize with access_token' do
      K2Subscribe.new('access_token')
    end

    it 'should raise an error when there is an empty access_token' do
      expect { K2Subscribe.new('') }.to raise_error ArgumentError
    end
  end

  describe '#webhook_subscribe' do
    let(:empty_event){ webhook_structure('') }
    let(:wrong_event){ webhook_structure('event_type') }

    let(:b2b){ webhook_structure('b2b_transaction_received') }
    let(:m2m){ webhook_structure('m2m_transaction_received') }
    let(:bg){ webhook_structure('buygoods_transaction_received') }
    let(:customer_created){ webhook_structure('customer_created') }
    let(:settlement){ webhook_structure('settlement_transfer_completed') }
    let(:bg_reversed){ webhook_structure('buygoods_transaction_reversed') }

    it 'raises error if event type does not match' do
      expect { @k2sub_not_exist.webhook_subscribe(wrong_event, 'wrong_event') }.to raise_error ArgumentError
      expect(WebMock).not_to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
    end

    it 'raises error if event type is empty' do
      expect { @k2subscriber.webhook_subscribe(empty_event, 'empty_event') }.to raise_error K2EmptyParams
      expect(WebMock).not_to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
    end

    it 'should send webhook subscription for buy goods received' do
      subscription_stub_request('buygoods_transaction_received', @callback_url)

      expect { @k2subscriber.webhook_subscribe(bg, 'webhook_secret') }.not_to raise_error
      expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
    end

    it 'should send webhook subscription for buy goods reversed' do
      subscription_stub_request('buygoods_transaction_reversed', @callback_url)

      expect { @k2subscriber.webhook_subscribe(bg_reversed, 'webhook_secret') }.not_to raise_error
      expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
    end

    it 'should send webhook subscription for customer created' do
      subscription_stub_request('customer_created', @callback_url)

      expect { @k2subscriber.webhook_subscribe(customer_created, 'webhook_secret') }.not_to raise_error
      expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
    end

    it 'should send webhook subscription for settlement' do
      subscription_stub_request('settlement_transfer_completed', @callback_url)

      expect { @k2subscriber.webhook_subscribe(settlement, 'webhook_secret') }.not_to raise_error
      expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
    end

    it 'should send webhook subscription for external till to till (b2b)' do
      subscription_stub_request('b2b_transaction_received', @callback_url)

      expect { @k2subscriber.webhook_subscribe(b2b, 'webhook_secret') }.not_to raise_error
      expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
    end

    it 'should send webhook subscription for merchant to merchant transaction' do
      subscription_stub_request('m2m_transaction_received', @callback_url)

      expect { @k2subscriber.webhook_subscribe(m2m, 'webhook_secret') }.not_to raise_error
      expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
    end
  end

  describe '#query_webhook' do
    it 'should query recent webhook subscription' do
      SpecConfig.custom_stub_request('get', @k2subscriber.location_url, '', 200)
      expect { expect(@k2subscriber.query_webhook).not_to eq(nil) }.not_to raise_error
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2subscriber.location_url)))
    end
  end

  describe '#query_resource_url' do
    it 'should query recent webhook subscription' do
      SpecConfig.custom_stub_request('get', @k2subscriber.location_url, '', 200)
      expect { expect(@k2subscriber.query_resource_url(@k2subscriber.location_url)).not_to eq(nil) }.not_to raise_error
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2subscriber.location_url)))
    end
  end
end
