include SpecStubRequest, K2Validation
RSpec.describe K2Transfer do
  before(:all) do
    @k2transfer = K2Transfer.new(K2AccessToken.new('KkcZEdj7qx7qfcFMyTWFaUXV7xZv8z8WIm72U06BiPI', 'mVoTlmrjsMw2mnfTXQrynz49ZcDX05Xp5wty-uNaZX8').request_token)

    @transfer_params = HashWithIndifferentAccess.new(currency: 'currency', value: 'value', callback_url: 'https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3')
  end

  describe '#transfer_funds' do
    it 'should create a blind transfer request' do
      SpecStubRequest.stub_request('post', K2Config.path_variable('transfers'), @transfer_params, 200)
      expect { @k2transfer.transfer_funds(nil, @transfer_params) }.not_to raise_error
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('transfers')))
    end

    it 'should create a targeted transfer request' do
      SpecStubRequest.stub_request('post', K2Config.path_variable('transfers'), @transfer_params, 200)
      expect { @k2transfer.transfer_funds('bb4e84a9-d944-42b1-a74a-e81ecec3576a', @transfer_params) }.not_to raise_error
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('transfers')))
    end
  end
end
