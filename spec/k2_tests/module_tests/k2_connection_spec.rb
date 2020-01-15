include SpecStubRequest
RSpec.describe K2Connect do

  context '#to_connect' do
    let(:token_hash) { { path_url: 'oauth', access_token: 'access_token', request_type: 'POST', class_type: 'class_type', params: 'body' } }
    let(:nil_token_hash) { { path_url: 'sub', access_token: '', request_type: 'POST', class_type: 'class_type', params: 'body' } }
    let(:push_hash) { { path_url: 'not_ouath', access_token: 'access_token', request_type: 'PUSH', class_type: 'class_type', params: 'body' } }
    let(:location_hash) { { path_url: 'not_ouath', access_token: 'access_token', request_type: 'POST', class_type: 'class_type', params: 'body' } }

    it 'should include key value pairs for request_type, class_type, params, path_url and access_token' do
      expect(nil_token_hash).to include(:path_url, :access_token, :request_type, :class_type, :params)
      expect(push_hash).to include(:path_url, :access_token, :request_type, :class_type, :params)
    end

    it 'should raise an error if access_token is empty' do
      expect { K2Connect.connect(nil_token_hash) }.to raise_error ArgumentError
    end

    it 'should raise an error if request_type is neither a POST nor GET' do
      expect { K2Connect.connect(push_hash) }.to raise_error ArgumentError
    end

    it 'should raise an error if response code is 400' do
      failed_stub_request (400)

      expect { K2Connect.connect(token_hash) }.to raise_error K2ConnectionError
    end

    it 'should raise an error if response code is 401' do
      failed_stub_request (401)

      expect { K2Connect.connect(token_hash) }.to raise_error K2ConnectionError
    end

    it 'should raise an error if response code is 403' do
      failed_stub_request (403)

      expect { K2Connect.connect(token_hash) }.to raise_error K2ConnectionError
    end

    it 'should raise an error if response code is 404' do
      failed_stub_request (404)

      expect { K2Connect.connect(token_hash) }.to raise_error K2ConnectionError
    end

    it 'should raise an error if response code is 405' do
      failed_stub_request (405)

      expect { K2Connect.connect(token_hash) }.to raise_error K2ConnectionError
    end

    it 'should raise an error if response code is 406' do
      failed_stub_request (406)

      expect { K2Connect.connect(token_hash) }.to raise_error K2ConnectionError
    end

    it 'should raise an error if response code is 410' do
      failed_stub_request (410)

      expect { K2Connect.connect(token_hash) }.to raise_error K2ConnectionError
    end

    it 'should raise an error if response code is 429' do
      failed_stub_request (429)

      expect { K2Connect.connect(token_hash) }.to raise_error K2ConnectionError
    end

    it 'should raise an error if response code is 500' do
      failed_stub_request (500)

      expect { K2Connect.connect(token_hash) }.to raise_error K2ConnectionError
    end

    it 'should raise an error if response code is 503' do
      failed_stub_request (503)

      expect { K2Connect.connect(token_hash) }.to raise_error K2ConnectionError
    end
  end
end
