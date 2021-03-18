include SpecConfig
RSpec.describe K2Subscribe do
  before(:all) do
    @access_token = K2AccessToken.new('_9fXMGROLmSegBhofF6z-qDKHH5L6FsbMn2MgG24Xnk', 'nom1cCNLeFkVc4qafcBu2bGqGWTKv9WgS8YvZR3yaq8').request_token
    @k2subscriber = K2Subscribe.new(@access_token)
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
    let(:empty_event){ webhook_structure('', 'till', 112233) }
    let(:wrong_event){ webhook_structure('event_type', 'till', 112233) }

    # Correct webhooks
    let(:b2b){ webhook_structure('b2b_transaction_received', 'till', 112233) }
    let(:m2m){ webhook_structure('m2m_transaction_received', 'company') }
    let(:bg){ webhook_structure('buygoods_transaction_received', 'till', 112233) }
    let(:customer_created){ webhook_structure('customer_created', 'company') }
    let(:settlement){ webhook_structure('settlement_transfer_completed', 'company') }
    let(:bg_reversed){ webhook_structure('buygoods_transaction_reversed', 'till', 112233) }
    # Incorrect Webhooks
    let(:incorrect_b2b){ webhook_structure('b2b_transaction_received', 'company', 112233) }
    let(:incorrect_m2m){ webhook_structure('m2m_transaction_received', 'till', 112233) }
    let(:incorrect_b2b){ webhook_structure('buygoods_transaction_received', 'company', 112233) }
    let(:incorrect_customer_created){ webhook_structure('customer_created', 'till', 112233) }
    let(:incorrect_settlement){ webhook_structure('settlement_transfer_completed', 'till', 112233) }
    let(:incorrect_bg_reversed){ webhook_structure('buygoods_transaction_reversed', 'company', 112233) }

    context 'invalid event type' do
      context 'event type does not exist' do
        it 'raises error if event type does not match' do
          expect { @k2subscriber.webhook_subscribe(wrong_event) }.to raise_error ArgumentError, 'Subscription Service does not Exist!'
        end
      end

      context 'event type is empty' do
        it 'raises error if event type is empty' do
          expect { @k2subscriber.webhook_subscribe(empty_event) }.to raise_error K2EmptyParams
        end
      end
    end

    context 'invalid event type and scope details' do
      context 'with customer created event type' do
        it 'should raise an error' do
          expect { @k2subscriber.webhook_subscribe(incorrect_customer_created) }.to raise_error ArgumentError, "Invalid scope till for the event type"
        end
      end

      context 'with settlement transfer event type' do
        it 'should raise an error' do
          expect { @k2subscriber.webhook_subscribe(incorrect_settlement) }.to raise_error ArgumentError, "Invalid scope till for the event type"
        end
      end

      context 'with merchant to merchant transaction event type' do
        it 'should raise an error' do
          expect { @k2subscriber.webhook_subscribe(incorrect_m2m) }.to raise_error ArgumentError, "Invalid scope till for the event type"
        end
      end
    end

    context 'valid event type' do
      context 'with buy goods received event type' do
        it 'should send a webhook subscription' do
          subscription_stub_request('buygoods_transaction_received', @callback_url)

          expect { @k2subscriber.webhook_subscribe(bg) }.not_to raise_error
          expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
        end
      end

      context 'with buy goods reversed event type' do
        it 'should send a webhook subscription' do
          subscription_stub_request('buygoods_transaction_reversed', @callback_url)

          expect { @k2subscriber.webhook_subscribe(bg_reversed) }.not_to raise_error
          expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
        end
      end

      context 'with customer created event type' do
        it 'should send a webhook subscription' do
          subscription_stub_request('customer_created', @callback_url)

          expect { @k2subscriber.webhook_subscribe(customer_created) }.not_to raise_error
          expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
        end
      end

      context 'with external till to till (b2b) event type' do
        it 'should send a webhook subscription' do
          subscription_stub_request('b2b_transaction_received', @callback_url)

          expect { @k2subscriber.webhook_subscribe(b2b) }.not_to raise_error
          expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
        end
      end

      context 'with settlement transfer event type' do
        it 'should send a webhook subscription for settlement' do
          subscription_stub_request('settlement_transfer_completed', @callback_url)

          expect { @k2subscriber.webhook_subscribe(settlement) }.not_to raise_error
          expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
        end
      end

      context 'with merchant to merchant transaction event type' do
        it 'should send a webhook subscription' do
          subscription_stub_request('m2m_transaction_received', @callback_url)

          expect { @k2subscriber.webhook_subscribe(m2m) }.not_to raise_error
          expect(WebMock).to have_requested(:post, K2Config.path_url('webhook_subscriptions'))
        end
      end
    end
  end

  describe '#query_webhook' do
    it 'should query recent webhook subscription' do
      SpecConfig.custom_stub_request('get', @k2subscriber.location_url, '', 200)
      expect { @k2subscriber.query_webhook }.not_to raise_error
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2subscriber.location_url)))
    end

    it 'returns a response body' do
      @k2subscriber.query_webhook
      expect(@k2subscriber.k2_response_body).not_to eq(nil)
    end
  end

  describe '#query_resource_url' do
    it 'should query recent webhook subscription' do
      SpecConfig.custom_stub_request('get', @k2subscriber.location_url, '', 200)
      expect { @k2subscriber.query_resource_url(@k2subscriber.location_url) }.not_to raise_error
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2subscriber.location_url)))
    end

    it 'returns a response body' do
      @k2subscriber.query_resource_url(@k2subscriber.location_url)
      expect(@k2subscriber.k2_response_body).not_to eq(nil)
    end
  end
end
