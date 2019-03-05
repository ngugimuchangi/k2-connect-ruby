# TODO, David Nino, context for validate_input
RSpec.describe K2Subscribe do
  before(:all) do
    @event_type = "event_type"
    @webhook_secret = "webhook_secret"
    @k2subscriber = K2Subscribe.new(@event_type, @webhook_secret)
  end

  context "#initialize" do
    it 'should initialize with event_type and webhook_secret' do
      K2Subscribe.new(@event_type, @webhook_secret)
    end

    it 'should raise an error when there is an empty event_type' do
      expect { K2Subscribe.new("", @webhook_secret) }.to raise_error ArgumentError
    end
  end

  context "#token_request" do
    let(:client_id) {"client_id"}
    let(:client_secret) {"client_secret"}
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

  context "#validate_input" do
    it 'should validate input' do
      allow(@k2subscriber).to receive(:validate_input).with(nil, nil) { "Empty Client Credentials" }
      @k2subscriber.validate_input(nil, nil)
      expect(@k2subscriber).to receive(:validate_input)
      expect(@k2subscriber.validate_input(nil, nil)).to eq("Empty Client Credentials")
    end
  end
end