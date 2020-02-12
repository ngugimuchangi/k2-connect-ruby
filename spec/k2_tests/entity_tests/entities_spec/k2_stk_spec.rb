include K2Validation
RSpec.describe K2Stk do
  before(:all) do
    # K2Stk Object
    @k2stk = K2Stk.new(K2AccessToken.new('BwuGu77i5M0SdCc9-R8haR3v0rIR5XsG4xYte27zxjs', '42aPhB6gF7u5n-r0-aL7fQkOVHAzoIYNPr4Nw-wCxQE').request_token)

    @mpesa_payments = { payment_channel: 'M-PESA', till_identifier: 444_555, subscriber: { first_name: 'first_name', last_name: 'last_name', phone: '0716230902', email: 'email@emailc.om'}, amount: { currency: 'currency', value: 2000 },
                        metadata: { customer_id: 123_456_789, reference: 123_456, notes: 'Payment for invoice 12345' }, _links: { callback_url: 'https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3' } }
  end

  context '#receive_mpesa_payments' do
    it 'validates input correctly' do
      expect { validate_input(@mpesa_payments, %w[payment_channel till_identifier subscriber amount metadata _links]) }.not_to raise_error
    end

    it 'should send incoming payment request' do
      SpecStubRequest.stub_request('post', K2Config.path_variable('incoming_payments'), @mpesa_payments, 200)
      @k2stk.receive_mpesa_payments(@mpesa_payments)
      expect(@k2stk.location_url).not_to eq(nil)
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('incoming_payments')))
    end
  end

  context '#query_status' do
    it 'should query payment request status' do
      SpecStubRequest.stub_request('get', 'api/v1/incoming_payments', '', 200)
      expect { @k2stk.query_status(@k2stk.location_url) }.not_to raise_error
      expect(@k2stk.k2_response_body).not_to eq(nil)
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2stk.location_url)))
    end
  end
end
