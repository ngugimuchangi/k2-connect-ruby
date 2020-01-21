include K2Validation
RSpec.describe K2Stk do
  before(:all) do
    @location_url = ''
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

    it 'should add pay recipient request' do
      test_response = SpecStubRequest.stub_request('post', K2Config.path_variable('incoming_payments'), @mpesa_payments, 200,
                                                   'http://localhost:3000/api/v1/incoming_payments/247b1bd8-f5a0-4b71-a898-f62f67b8ae1c')
      @location_url = Yajl::Parser.parse(test_response.header.to_json)["location"][0]
      expect(Yajl::Parser.parse(test_response.header.to_json)["location"][0]).not_to eq(nil)
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.complete_url('incoming_payments')))
    end
  end

  context '#query_status' do
    pending("should query payment request status: Doesn't Provide Complete Resource URL")
    it 'should query payment request status' do
      test_response = SpecStubRequest.stub_request('get', 'api/v1/incoming_payments', '', 200, nil, @query_incoming_payment_result)
      expect(test_response.body).not_to eq(nil)
      expect(WebMock).to have_requested(:get, URI.parse('http://127.0.0.1:3000/api/v1/incoming_payments'))
    end
  end
end
