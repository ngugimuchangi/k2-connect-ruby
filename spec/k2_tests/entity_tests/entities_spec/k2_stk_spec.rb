include K2Validation
RSpec.describe K2Stk do
  before(:all) do
    # K2Stk Object
    @k2stk = K2Stk.new(K2AccessToken.new('KkcZEdj7qx7qfcFMyTWFaUXV7xZv8z8WIm72U06BiPI', 'mVoTlmrjsMw2mnfTXQrynz49ZcDX05Xp5wty-uNaZX8').request_token)

    @mpesa_payments = {
        payment_channel: 'M-PESA',
        till_identifier: 444_555,
        first_name: 'first_name',
        last_name: 'last_name',
        phone: '0716230902',
        email: 'email@emailc.om',
        currency: 'currency',
        value: 2000,
        metadata: {
            customer_id: 123_456_789,
            reference: 123_456,
            notes: 'Payment for invoice 12345'
        },
        callback_url: 'https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3'
    }
  end

  describe '#receive_mpesa_payments' do
    it 'validates input correctly' do
      expect { validate_input(@mpesa_payments, %w[payment_channel till_identifier first_name last_name phone email currency value metadata callback_url]) }.not_to raise_error
    end

    it 'should send incoming payment request' do
      SpecStubRequest.stub_request('post', K2Config.path_url('incoming_payments'), @mpesa_payments, 200)
      @k2stk.receive_mpesa_payments(@mpesa_payments)
      expect(@k2stk.location_url).not_to eq(nil)
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('incoming_payments')))
    end
  end

  describe '#query_status' do
    it 'should query payment request status' do
      SpecStubRequest.stub_request('get', K2Config.path_url('incoming_payments'), '', 200)
      expect { @k2stk.query_status(@k2stk.location_url) }.not_to raise_error
      expect(@k2stk.k2_response_body).not_to eq(nil)
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2stk.location_url)))
    end
  end
end
