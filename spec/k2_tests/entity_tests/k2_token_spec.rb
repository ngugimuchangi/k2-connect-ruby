include SpecStubRequest
RSpec.describe K2AccessToken do
  # Set Base URL
  before(:each) do
    K2Config.set_base_url('http://127.0.0.1:3000')
  end

  context '#initialize' do
    it 'should initialize with access_token' do
      K2AccessToken.new('BwuGu77i5M0SdCc9-R8haR3v0rIR5XsG4xYte27zxjs', '42aPhB6gF7u5n-r0-aL7fQkOVHAzoIYNPr4Nw-wCxQE')
    end

    it 'should raise an error when there is an empty client credentials' do
      expect { K2AccessToken.new('', '') }.to raise_error ArgumentError
    end
  end

  context '#request_token' do
    it 'should return an access token' do
      # token_request stub components
      #request_body = { client_id: 'BwuGu77i5M0SdCc9-R8haR3v0rIR5XsG4xYte27zxjs', client_secret: '42aPhB6gF7u5n-r0-aL7fQkOVHAzoIYNPr4Nw-wCxQE', grant_type: 'client_credentials' }
      #request_headers = { 'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection': 'keep-alive', 'Content-Type': 'application/json', 'Keep-Alive': '30',
      #                    'User-Agent': 'Ruby' }
      #return_response = { access_token: '123ABC456def', token_type: 'bearer', expires_in: 3_600, refresh_token: '789GHI101jkl', scope: 'read', uid: 123,
      #                    info: { name: 'David J. Kariuki', email: 'dijon@david.yoh' } }
      ## pay_recipients stub method
      #mock_stub_request('post', 'oauth/token', request_body, request_headers, 200, return_response)

      k2token = K2AccessToken.new('BwuGu77i5M0SdCc9-R8haR3v0rIR5XsG4xYte27zxjs', '42aPhB6gF7u5n-r0-aL7fQkOVHAzoIYNPr4Nw-wCxQE')
      expect { k2token.request_token }.not_to raise_error
      expect(k2token.access_token).not_to eq(nil)
    end
  end
end