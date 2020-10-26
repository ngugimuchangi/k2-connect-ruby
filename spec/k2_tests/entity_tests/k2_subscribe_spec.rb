include SpecConfig
RSpec.describe K2Subscribe do
  before(:all) do
    @access_token = K2AccessToken.new('ReMYAYdLKcg--XNmKhzkLNTIbXPvOUPs3hyycUF8WmI', '4707e306330759f4b63716f0525f6634a4685b4b4bf75b3381f1244ee77eb3fa').request_token
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

    context 'invalid event type' do
      context 'event type does not exist' do
        it 'raises error if event type does not match' do
          expect { @k2sub_not_exist.webhook_subscribe(wrong_event, 'wrong_event') }.to raise_error ArgumentError
          expect(WebMock).not_to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
        end
      end

      context 'event type is empty' do
        it 'raises error if event type is empty' do
          expect { @k2subscriber.webhook_subscribe(empty_event, 'empty_event') }.to raise_error K2EmptyParams
          expect(WebMock).not_to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
        end
      end
    end

    context 'valid event type' do
      context 'with buy goods received event type' do
        it 'should send webhook subscription' do
          subscription_stub_request('buygoods_transaction_received', @callback_url)

          expect { @k2subscriber.webhook_subscribe(bg, 'ruby_sdk_webhook_secret') }.not_to raise_error
          expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
        end
      end

      context 'with buy goods reversed event type' do
        it 'should send webhook subscription' do
          subscription_stub_request('buygoods_transaction_reversed', @callback_url)

          expect { @k2subscriber.webhook_subscribe(bg_reversed, 'ruby_sdk_webhook_secret') }.not_to raise_error
          expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
        end
      end

      context 'with customer created event type' do
        it 'should send webhook subscription' do
          subscription_stub_request('customer_created', @callback_url)

          expect { @k2subscriber.webhook_subscribe(customer_created, 'ruby_sdk_webhook_secret') }.not_to raise_error
          expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
        end
      end

      context 'with external till to till (b2b) event type' do
        it 'should send webhook subscription' do
          subscription_stub_request('b2b_transaction_received', @callback_url)

          expect { @k2subscriber.webhook_subscribe(b2b, 'ruby_sdk_webhook_secret') }.not_to raise_error
          expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
        end
      end

      context 'with settlement transfer event type' do
        it 'should send webhook subscription for settlement' do
          subscription_stub_request('settlement_transfer_completed', @callback_url)

          expect { @k2subscriber.webhook_subscribe(settlement, 'ruby_sdk_webhook_secret') }.not_to raise_error
          expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
        end
      end

      context 'with merchant to merchant transaction event type' do
        it 'should send webhook subscription' do
          subscription_stub_request('m2m_transaction_received', @callback_url)

          expect { @k2subscriber.webhook_subscribe(m2m, 'ruby_sdk_webhook_secret') }.not_to raise_error
          expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
        end
      end
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
