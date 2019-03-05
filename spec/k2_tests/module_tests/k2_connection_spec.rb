RSpec.describe K2Connect do

  context "#to_connect" do
    let(:token_hash) { {path_url: "ouath", access_token: "access_token", request_type: "POST", class_type: "class_type", params: "body"} }
    let(:nil_token_hash) { {path_url: "sub", access_token: "", request_type: "POST", class_type: "class_type", params: "body"} }
    let(:get_hash) { {path_url: "not_ouath", access_token: "access_token", request_type: "GET", class_type: "class_type", params: "body"} }
    let(:post_hash) { {path_url: "not_ouath", access_token: "access_token", request_type: "POST", class_type: "class_type", params: "body"} }

    it 'should include key value pairs for request_type, class_type, params, path_url and access_token' do
      expect(token_hash).to include(:path_url, :access_token, :request_type, :class_type, :params)
      expect(nil_token_hash).to include(:path_url, :access_token, :request_type, :class_type, :params)
      expect(get_hash).to include(:path_url, :access_token, :request_type, :class_type, :params)
      expect(post_hash).to include(:path_url, :access_token, :request_type, :class_type, :params)
    end

    it 'should raise an error if access_token is empty' do
      expect { K2Connect.to_connect(nil_token_hash) }.to raise_error ArgumentError
    end

    it 'should send a GET request if request_type is GET' do
      allow(K2Connect).to receive(:to_connect).with(Hash)
      K2Connect.to_connect(get_hash)
      expect(get_hash).to include(request_type: "GET")
    end

    it 'should send a POST request if request_type is POST' do
      allow(K2Connect).to receive(:to_connect).with(Hash)
      K2Connect.to_connect(post_hash)
      expect(post_hash).to include(request_type: "POST")
    end

    it 'should return an access_token if path_url is ouath' do
      allow(K2Connect).to receive(:to_connect).with(Hash) { "access_token" }
      K2Connect.to_connect(token_hash)
      expect(token_hash).to include(path_url: "ouath")
      expect(K2Connect).to have_received(:to_connect)
      expect(K2Connect.to_connect(Hash)).to eq("access_token")
    end

    it 'should return a location url if path_url is not ouath' do
      allow(K2Connect).to receive(:to_connect).with(Hash) { "location" }
      K2Connect.to_connect(post_hash)
      expect(post_hash).not_to include(path_url: "ouath")
      expect(K2Connect).to have_received(:to_connect)
      expect(K2Connect.to_connect(Hash)).to eq("location")
    end
  end
end