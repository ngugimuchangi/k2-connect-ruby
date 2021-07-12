RSpec.describe K2AccessToken do
  before(:all) do
    @client_id = 'T1RyrPntqO4PJ35RLv6IVfPKRyg6gVoMvXEwEBin9Cw'
    @client_secret = 'Ywk_J18RySqLOmhhhVm8fhh4FzJTUzVcZJ03ckNpZK8'
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

  context "Other access token actions" do
    let(:k2token) { K2AccessToken.new(@client_id, @client_secret) }
    let(:access_token) { k2token.request_token }
    let(:misc_token_params) { { client_id: @client_id, client_secret: @client_secret, token: access_token } }

    describe '#revoke_token' do
      it 'should return an access token' do
        SpecConfig.custom_stub_request('post', K2Config.path_url('revoke_token'), misc_token_params, 200)
        expect { k2token.revoke_token(access_token) }.not_to raise_error
      end
    end

    describe '#introspect_token' do
      it 'should return an access token' do
        SpecConfig.custom_stub_request('post', K2Config.path_url('introspect_token'), misc_token_params, 200)
        expect { k2token.introspect_token(access_token) }.not_to raise_error
      end
    end

    describe '#token_info' do
      it 'should return an access token' do
        SpecConfig.custom_stub_request('get', K2Config.path_url('token_info'), '', 200)
        expect { k2token.token_info(access_token) }.not_to raise_error
      end
    end
  end
end