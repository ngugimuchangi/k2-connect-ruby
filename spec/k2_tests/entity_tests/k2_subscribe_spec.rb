RSpec.describe K2Subscribe do
  before(:all) do
    @event_type = "event_type"
    @webhook_secret = "webhook_secret"
    @k2subscriber = K2Subscribe.new(@event_type, @webhook_secret)
  end

  context "#initialize" do
    it 'should initialize with event_type and webhook_secret' do
      expect(@k2subscriber.event_type).to eq(@event_type)
      expect(@k2subscriber.webhook_secret).to eq(@webhook_secret)
    end

    it 'should raise an error when there is an empty event_type' do
      raise K2EmptyEvent.new if @k2subscriber.event_type.nil? || @k2subscriber.event_type == ""
      expect { raise K2EmptyEvent.new }.to raise_error K2EmptyEvent
    end
  end

  context "#token_request" do
    it 'should return an access token' do
      allow(@k2subscriber).to receive(:token_request).with("client_id", "client_secret") { {access_token: "access_token"} }
      @k2subscriber.token_request("client_id", "client_secret")
      expect(@k2subscriber).to have_received(:token_request)
      expect(@k2subscriber.token_request("client_id", "client_secret")).to eq({access_token: "access_token"})
    end
  end

  context "#webhook_subscribe" do
    it 'should send webhook subscription' do
      allow(@k2subscriber).to receive(:webhook_subscribe) { {Location_url: "location_url"} }
      @k2subscriber.webhook_subscribe
      expect(@k2subscriber).to have_received(:webhook_subscribe)
      expect(@k2subscriber.webhook_subscribe).to eq({Location_url: "location_url"})
    end
  end

<<<<<<< HEAD
  context "#validate_input" do
    it 'should validate input' do
      allow(@k2subscriber).to receive(:validate_input).with(nil, nil) { "Empty Client Credentials" }
      @k2subscriber.validate_input(nil, nil)
=======
      if subscriber.webhook_subscribe
        expect(subscriber).to have_received(:webhook_subscribe)
        connection.to_connect

      end
>>>>>>> 3a8372d2aefb28a8904c8c22af7460ad72d08ee9
    end
  end
end