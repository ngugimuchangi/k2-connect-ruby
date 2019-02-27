RSpec.describe K2Subscribe do
  let!(:subscriber) { double("Subscription") }
  let!(:connection) { double("Connection Module") }

  # before(:each) do  end
  # subject { K2Subscribe.new("buygoods_transaction_received", "webhook_secret") }

  context "Requesting Access Token" do
    let(:token_params) { {client_id: "Client ID", client_secret: "Client Secret"} }
    let(:token_hash) { {path_url: "Path URL", params: token_params} }

    it 'should send a request with hash parameter' do
      expect(token_hash).to be_a_kind_of(Hash)
      expect(token_hash).to have_key(:path_url).and have_key(:params)
    end

    it 'should return an access token' do
      allow(subscriber).to receive(:token_request).with("client_id", "client_secret") { true }
      allow(connection).to receive(:to_connect).and_return(access_token: "access_token")

      if subscriber.token_request("client_id", "client_secret")
        expect(subscriber).to have_received(:token_request)
        connection.to_connect
        expect(connection).to have_received(:to_connect)
        expect(connection.to_connect).to eq(access_token: "access_token")
      end
    end
  end

  context "Webhook Subscribing" do
    let(:request_body) { {event_type: "Event Type", secret: "Webhook Secret"} }
    it 'should have a correct Request Body' do
      expect(request_body).not_to be_nil
      expect(request_body).to have_key(:event_type).and have_key(:secret)

    end
    it 'should send webhook subscription' do
      allow(subscriber).to receive(:webhook_subscribe) { true }
      allow(connection).to receive(:to_connect).and_return(Location_url: "location_url")

      if subscriber.webhook_subscribe
        expect(subscriber).to have_received(:webhook_subscribe)
        connection.to_connect
        expect(connection).to have_received(:to_connect)
        expect(connection.to_connect).to eq(Location_url: "location_url")
      end
    end
  end
end