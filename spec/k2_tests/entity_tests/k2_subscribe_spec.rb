require 'faker'

RSpec.describe K2ConnectRuby::K2Entity::K2Subscribe do
  before(:each) do
    stub_request(:post, 'https://sandbox.kopokopo.com/oauth/token').to_return(body: { access_token: "access_token" }.to_json, status: 200)
    @access_token = K2ConnectRuby::K2Entity::K2Token.new('client_id', 'client_secret').request_token
    @k2subscriber = K2ConnectRuby::K2Entity::K2Subscribe.new(@access_token)
    stub_request(:post, /sandbox.kopokopo.com/).to_return(status: 201, body: {data: "some_data"}.to_json, headers: { location: Faker::Internet.url })
  end

  describe '#initialize' do
    it 'should initialize with access_token' do
      K2ConnectRuby::K2Entity::K2Subscribe.new('access_token')
    end

    it 'should raise an error when there is an empty access_token' do
      expect { K2ConnectRuby::K2Entity::K2Subscribe.new('') }.to raise_error ArgumentError
    end
  end

  describe '#webhook_subscribe' do
    let(:empty_event){ webhook_structure('', 'till', 112233) }
    let(:wrong_event){ webhook_structure('event_type', 'till', 112233) }

    # Correct webhooks
    let(:b2b){ webhook_structure('b2b_transaction_received', 'till', 112233) }
    let(:bg){ webhook_structure('buygoods_transaction_received', 'till', 112233) }
    let(:customer_created){ webhook_structure('customer_created', 'company') }
    let(:settlement){ webhook_structure('settlement_transfer_completed', 'company') }
    let(:bg_reversed){ webhook_structure('buygoods_transaction_reversed', 'till', 112233) }
    # Incorrect Webhooks
    let(:incorrect_b2b){ webhook_structure('b2b_transaction_received', 'company', 112233) }
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
          expect { @k2subscriber.webhook_subscribe(empty_event) }.to raise_error K2ConnectRuby::K2EmptyParams
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
    end

    context 'valid event type' do
      context 'with buy goods received event type' do
        it 'should send a webhook subscription' do
          aggregate_failures do
            expect { @k2subscriber.webhook_subscribe(bg) }.not_to(raise_error)
            expect(WebMock).to have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.path_url('webhook_subscriptions'))
          end
        end
      end

      context 'with buy goods reversed event type' do
        it 'should send a webhook subscription' do
          aggregate_failures do
            expect { @k2subscriber.webhook_subscribe(bg_reversed) }.not_to(raise_error)
            expect(WebMock).to have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.path_url('webhook_subscriptions'))
          end
        end
      end

      context 'with customer created event type' do
        it 'should send a webhook subscription' do
          aggregate_failures do
            expect { @k2subscriber.webhook_subscribe(customer_created) }.not_to(raise_error)
            expect(WebMock).to have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.path_url('webhook_subscriptions'))
          end
        end
      end

      context 'with external till to till (b2b) event type' do
        it 'should send a webhook subscription' do
          aggregate_failures do
            expect { @k2subscriber.webhook_subscribe(b2b) }.not_to(raise_error)
            expect(WebMock).to have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.path_url('webhook_subscriptions'))
          end
        end
      end

      context 'with settlement transfer event type' do
        it 'should send a webhook subscription for settlement' do
          aggregate_failures do
            expect { @k2subscriber.webhook_subscribe(settlement) }.not_to(raise_error)
            expect(WebMock).to have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.path_url('webhook_subscriptions'))
          end
        end
      end
    end
  end

  describe '#query_webhook' do
    before(:each) do
      bg = webhook_structure('buygoods_transaction_received', 'till', 112233)
      @k2subscriber.webhook_subscribe(bg)
      stub_request(:get, @k2subscriber.location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
    end

    it 'should query recent webhook subscription' do
      aggregate_failures do
        expect { @k2subscriber.query_webhook }.not_to(raise_error)
        expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2subscriber.location_url)))
      end
    end

    it 'returns a response body' do
      @k2subscriber.query_webhook
      expect(@k2subscriber.k2_response_body).not_to(eq(nil))
    end
  end

  describe '#query_resource_url' do
    before(:each) do
      bg = webhook_structure('buygoods_transaction_received', 'till', 112233)
      @k2subscriber.webhook_subscribe(bg)
      stub_request(:get, @k2subscriber.location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
    end

    it 'should query recent webhook subscription' do
      aggregate_failures do
        expect { @k2subscriber.query_resource_url(@k2subscriber.location_url) }.not_to(raise_error)
        expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2subscriber.location_url)))
      end
    end

    it 'returns a response body' do
      @k2subscriber.query_resource_url(@k2subscriber.location_url)
      expect(@k2subscriber.k2_response_body).not_to(eq(nil))
    end
  end

  def webhook_structure(event_type, scope, scope_reference = nil)
    {
      event_type: event_type,
      url: Faker::Internet.url,
      scope: scope,
      scope_reference: scope_reference,
    }
  end

end
