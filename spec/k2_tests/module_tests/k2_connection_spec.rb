include SpecStubRequest
RSpec.describe K2Connect do

  describe '#to_connect' do
    let(:nil_token_hash) { { path_url: 'sub', access_token: '', request_type: 'post', class_type: 'class_type', params: 'body' } }
    let(:invalid_hash) { { path_url: 'not_ouath', access_token: 'access_token', request_type: 'PUSH', class_type: 'class_type', params: 'body' } }

    it 'should raise an error if access_token is empty' do
      expect { K2Connect.make_request(nil_token_hash) }.to raise_error ArgumentError
    end

    it 'should raise an error if request_type is neither a post nor get' do
      expect { K2Connect.make_request(invalid_hash) }.to raise_error NameError
    end

  end
end
