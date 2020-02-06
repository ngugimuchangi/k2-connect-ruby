include K2Validation
RSpec.describe K2Stk do
  before(:all) do
    # K2Stk Object
    @k2stk = K2Stk.new(K2AccessToken.new('BwuGu77i5M0SdCc9-R8haR3v0rIR5XsG4xYte27zxjs', '42aPhB6gF7u5n-r0-aL7fQkOVHAzoIYNPr4Nw-wCxQE').request_token)

    @mpesa_payments = { payment_channel: 'M-PESA', till_identifier: 444_555, subscriber: { first_name: 'first_name', last_name: 'last_name', phone: '0716230902', email: 'email@emailc.om'}, amount: { currency: 'currency', value: 2000 },
                        metadata: { customer_id: 123_456_789, reference: 123_456, notes: 'Payment for invoice 12345' }, _links: { callback_url: 'http://127.0.0.1:3003' } }
    @query_incoming_payment_result = { payment_request: { payment_channel: 'M-PESA', 'till_identifier': 'till_identifier', status: 'Success', subscriber: { first_name: 'Joe', last_name: 'Buyer', phone: '+254999999999', email: 'jbuyer@mail.net' },
                             amount: { currency: 'KES', value: 'value' }, metadata: { customer_id: 'customer_id', reference: 'reference', notes: 'Payment for invoice 12345' }, _links: { call_back_url: 'http://127.0.0.1:3003' } },
          payment_request_result: { id: 'cac95329-9fa5-42f1-a4fc-c08af7b868fb', resourceId: 'cdb5f11f-62df-e611-80ee-0aa34a9b2388', topic: 'payment_request', created_at: '2018-06-20T22:45:12.790Z', status: 'Success',
                                    event: { type: 'Payment Request', resource: { reference: 'KKPPLLMMNN', origination_time: '2017-01-20T22:45:12.790Z', sender_msisdn: '+2549703119050', amount: 'amount',
                                                         currency: 'KES', till_number: 'till_number', system: 'Lipa Na M-PESA', status: 'Received', sender_first_name: 'John',
                                                         sender_middle_name: 'O', sender_last_name: 'Doe' }, errors: [] },
                                    metadata: { customer_id: 'customer_id', reference: 'reference', notes: 'Payment for invoice 123456' },
                                    _links: { self: 'https://api-sandbox.kopokopo.com/payment_requests/cac95329-9fa5-42f1-a4fc-c08af7b868fb',
                                              payment_request_result: 'https://api-sandbox.kopokopo.com/payment_request_results/cac95329-9fa5-42f1-a4fc-c08af7b868fb',
                                              resource: 'https://api-sandbox.kopokopo.com/buygoods_transaction/cdb5f11f-62df-e611-80ee-0aa34a9b2388' } } }
  end

  context '#receive_mpesa_payments' do
    it 'validates input correctly' do
      expect { validate_input(@mpesa_payments, %w[payment_channel till_identifier subscriber amount metadata _links]) }.not_to raise_error
    end

    it 'should send incoming payment request' do
      SpecStubRequest.stub_request('post', K2Config.path_variable('incoming_payments'), @mpesa_payments, 200)
      @k2stk.receive_mpesa_payments(@mpesa_payments)
      expect(@k2stk.location_url).not_to eq(nil)
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.complete_url('incoming_payments')))
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
