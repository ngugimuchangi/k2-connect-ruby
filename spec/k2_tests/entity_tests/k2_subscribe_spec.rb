include SpecStubRequest
RSpec.describe K2Subscribe do
  before(:all) do
    @access_token = K2AccessToken.new('BwuGu77i5M0SdCc9-R8haR3v0rIR5XsG4xYte27zxjs', '42aPhB6gF7u5n-r0-aL7fQkOVHAzoIYNPr4Nw-wCxQE').request_token
    @k2subscriber = K2Subscribe.new(@access_token)
    @k2sub_not_exist = K2Subscribe.new(@access_token)
    @callback_url = K2Config.callback_url('webhook')
  end

  context '#initialize' do
    it 'should initialize with access_token' do
      K2Subscribe.new('access_token')
    end

    it 'should raise an error when there is an empty access_token' do
      expect { K2Subscribe.new('') }.to raise_error ArgumentError
    end
  end

  context '#webhook_subscribe' do
    it 'raises error if event type does not match' do
      expect { @k2sub_not_exist.webhook_subscribe('event_type', @callback_url) }.to raise_error ArgumentError
    end

    it 'raises error if event type is empty' do
      expect { @k2subscriber.webhook_subscribe('', @callback_url) }.to raise_error ArgumentError
    end

    it 'should send webhook subscription for buy goods received' do
      # webhook_subscribe buy goods received stub method
      subscription_stub_request('buygoods_transaction_received', @callback_url)

      expect { @k2subscriber.webhook_subscribe('webhook_secret','buygoods_transaction_received', @callback_url) }.not_to raise_error
    end

    it 'should send webhook subscription for buy goods reversed' do
      # webhook_subscribe buy goods reversed stub method
      subscription_stub_request('buygoods_transaction_reversed', @callback_url)

      expect { @k2subscriber.webhook_subscribe('webhook_secret','buygoods_transaction_reversed', @callback_url) }.not_to raise_error
    end

    it 'should send webhook subscription for customer created' do
      # webhook_subscribe customer created stub method
      subscription_stub_request('customer_created', @callback_url)

      expect { @k2subscriber.webhook_subscribe('webhook_secret','customer_created', @callback_url) }.not_to raise_error
    end

    it 'should send webhook subscription for settlement' do
      # webhook_subscribe settlement stub method
      subscription_stub_request('settlement', @callback_url)

      expect { @k2subscriber.webhook_subscribe('webhook_secret','settlement_transfer_completed', @callback_url) }.not_to raise_error
    end

    it 'should send webhook subscription for external till to till (b2b)' do
      # webhook_subscribe external till to till (b2b) stub method
      subscription_stub_request('b2b_transaction_received', @callback_url)

      expect { @k2subscriber.webhook_subscribe('webhook_secret','external_till_to_till', @callback_url) }.not_to raise_error
    end

    it 'should send webhook subscription for merchant to merchant transaction' do
      # webhook_subscribe merchant to merchant transaction stub method
      subscription_stub_request('merchant_to_merchant', @callback_url)

      expect { @k2subscriber.webhook_subscribe('webhook_secret','k2_merchant_to_merchant', @callback_url) }.not_to raise_error
    end
  end
end
