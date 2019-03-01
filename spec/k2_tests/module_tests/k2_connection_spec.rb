RSpec.describe K2Connect do

  context "#to_connect" do
    let(:access_token) {  }
    let(:connection_hash) { {path_url: "ouath", access_token: "access_token", is_get_request: true, params: "params", is_subscribe: false} }
    let(:connection_hash2) { {path_url: "not_ouath", access_token: "access_token", is_get_request: false, params: "params", is_subscribe: true} }
    it 'should raise an error if repeat token_request' do
      raise K2RepeatTokenRequest.new unless access_token.nil?
      expect { raise K2RepeatTokenRequest.new }.to raise_error K2RepeatTokenRequest
    end

    it 'should include key value pairs for is_get_request, is_subscribe, params, path_url and access_token' do
      expect(connection_hash).to include(:path_url, :access_token, :is_get_request, :is_subscribe, :params)
      expect(connection_hash2).to include(:path_url, :access_token, :is_get_request, :is_subscribe, :params)
    end

    it 'should raise an error if access_token is empty' do
      raise K2EmptyAccessToken.new if connection_hash[:access_token].nil? || connection_hash[:access_token]==""
      expect { raise K2EmptyAccessToken.new }.to raise_error K2EmptyAccessToken
    end

    it 'should send a GET request if is_get_request is true' do
      allow(K2Connect).to receive(:to_connect).with(Hash)
      K2Connect.to_connect(connection_hash)
      expect(connection_hash).to include(is_get_request: true)
    end

    it 'should send a POST request if is_get_request is false' do
      allow(K2Connect).to receive(:to_connect).with(Hash)
      K2Connect.to_connect(connection_hash2)
      expect(connection_hash2).to include(is_get_request: false)
    end

    it 'should return an access_token if path_url is ouath' do
      allow(K2Connect).to receive(:to_connect).with(Hash) { "access_token" }
      K2Connect.to_connect(connection_hash)
      expect(connection_hash).to include(path_url: "ouath")
      expect(K2Connect).to have_received(:to_connect)
      expect(K2Connect.to_connect(Hash)).to eq("access_token")
    end

    it 'should return a location url if path_url is not ouath' do
      allow(K2Connect).to receive(:to_connect).with(Hash) { "location" }
      K2Connect.to_connect(connection_hash2)
      expect(connection_hash2).not_to include(path_url: "ouath")
      expect(K2Connect).to have_received(:to_connect)
      expect(K2Connect.to_connect(Hash)).to eq("location")
    end
  end
end