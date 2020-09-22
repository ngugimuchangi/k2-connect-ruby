RSpec.describe K2AccessToken do
  before(:all) do
    @client_id = 'ReMYAYdLKcg--XNmKhzkLNTIbXPvOUPs3hyycUF8WmI'
    @client_secret = '4707e306330759f4b63716f0525f6634a4685b4b4bf75b3381f1244ee77eb3fa'
    @token_request_body = { client_id: @client_id, client_secret: @client_secret, grant_type: 'client_credentials' }
  end

  describe '#initialize' do
    it 'should initialize with access_token' do
      K2AccessToken.new(@client_id, @client_secret)
    end

    it 'should raise an error when there is an empty client credentials' do
      expect { K2AccessToken.new('', '') }.to raise_error ArgumentError
    end
  end

  describe '#request_token' do
    let(:k2token) { K2AccessToken.new(@client_id, @client_secret) }
    it 'should return an access token' do
      SpecConfig.custom_stub_request('post', K2Config.path_url('oauth_token'), @token_request_body, 200)
      expect { k2token.request_token }.not_to raise_error
      expect(k2token.access_token).not_to eq(nil)
    end
  end
end