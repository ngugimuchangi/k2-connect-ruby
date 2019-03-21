RSpec.describe K2Connect do
  context '#to_connect' do
    let(:token_hash) { { path_url: 'ouath', access_token: 'access_token', request_type: 'POST', class_type: 'class_type', params: 'body' } }
    let(:nil_token_hash) { { path_url: 'sub', access_token: '', request_type: 'POST', class_type: 'class_type', params: 'body' } }
    let(:push_hash) { { path_url: 'not_ouath', access_token: 'access_token', request_type: 'PUSH', class_type: 'class_type', params: 'body' } }
    let(:location_hash) { { path_url: 'not_ouath', access_token: 'access_token', request_type: 'POST', class_type: 'class_type', params: 'body' } }

    it 'should include key value pairs for request_type, class_type, params, path_url and access_token' do
      expect(nil_token_hash).to include(:path_url, :access_token, :request_type, :class_type, :params)
      expect(push_hash).to include(:path_url, :access_token, :request_type, :class_type, :params)
    end

    it 'should raise an error if access_token is empty' do
      expect { K2Connect.to_connect(nil_token_hash) }.to raise_error ArgumentError
    end

    it 'should raise an error if request_type is neither a POST nor GET' do
      expect { K2Connect.to_connect(push_hash) }.to raise_error ArgumentError
    end
  end
end
