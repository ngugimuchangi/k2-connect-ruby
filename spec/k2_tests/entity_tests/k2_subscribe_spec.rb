RSpec.describe K2Subscribe do
  before(:all) do
    @event_type = "buygoods_transaction_received"
    @webhook_secret = "webhook_secret"
    @k2subscriber = K2Subscribe.new(@event_type, @webhook_secret)
    @k2sub_not_exist = K2Subscribe.new("event_type", @webhook_secret)
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
    it 'raises an error if empty Credentials given' do
      expect{ @k2subscriber.token_request("", nil) }.to raise_error ArgumentError
    end

    it 'should return an access token' do
      expect{ @k2subscriber.token_request("client_id", "client_secret") }.not_to raise_error
      expect(@k2subscriber.access_token).to eq("123ABC456def")
    end
  end

  context "#webhook_subscribe" do
    it 'raise error if event type does not match' do
      expect{ @k2sub_not_exist.webhook_subscribe }.to raise_error ArgumentError
    end

    it 'should send webhook subscription' do
      expect{ @k2subscriber.webhook_subscribe }.not_to raise_error
    end
  end

end