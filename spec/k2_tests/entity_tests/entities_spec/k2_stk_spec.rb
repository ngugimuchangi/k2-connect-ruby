include SpecStubRequest
RSpec.describe K2Stk do
  before(:all) do
    @k2stk = K2Stk.new('access_token')
    @k2stk.extend(K2Validation)
    @mpesa_payments = HashWithIndifferentAccess.new(first_name: 'first_name', last_name: 'last_name', phone: '0716230902', email: 'email@emailc.om', currency: 'currency', value: 'value')
    @mpesa_payments_hash = { first_name: 'first_name', last_name: 'last_name', phone: '0716230902', email: 'email@emailc.om', currency: 'currency', value: 'value' }
    @query_input = 'https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/payment_requests'
  end

  it 'should include K2Validation Module and inherit from K2Entity' do
    expect(K2Stk).to be < K2Entity
    expect(K2Stk).to include(K2Validation)
  end

  context '#receive_mpesa_payments' do
    it 'validates input correctly' do
      expect { @k2stk.validate_input(@mpesa_payments, %w[first_name last_name phone email currency value]) }.not_to raise_error
    end

    it 'should add pay recipient request' do
      # receive_mpesa_payments stub components
      request_body = { payment_channel: 'M-PESA',
                       till_identifier: 444_555,
                       subscriber: { first_name: 'first_name', last_name: 'last_name', phone: '0716230902', email: 'email@emailc.om'},
                       amount: { currency: 'currency', value: 'value' },
                       metadata: { customer_id: 123_456_789, reference: 123_456, notes: 'Payment for invoice 12345' },
                       call_back_url: 'https://call_back_to_your_app.your_application.com' }
      return_response = { location: 'https://api-sandbox.kopokopo.com/payment_requests/247b1bd8-f5a0-4b71-a898-f62f67b8ae1c' }
      # receive_mpesa_payments stub method
      mock_stub_request('post', 'payment_requests', request_body,200, return_response)

      expect { @k2stk.receive_mpesa_payments(@mpesa_payments) }.not_to raise_error
    end
  end

  context '#query_status' do
    it 'validates query URL correctly' do
      expect { @k2stk.validate_url(@query_input) }.not_to raise_error
    end

    it 'should query payment request status' do
      # query_stk payment stub components
      request_body = 'null'
      return_response = {
          payment_request: { payment_channel: 'M-PESA',
                             'till_identifier': 'till_identifier',
                             status: 'Success',
                             subscriber: { first_name: 'Joe', last_name: 'Buyer', phone: '+254999999999', email: 'jbuyer@mail.net' },
                             amount: { currency: 'KES', value: 'value' },
                             metadata: { customer_id: 'customer_id', reference: 'reference', notes: 'Payment for invoice 12345' },
                             _links: { call_back_url: 'https://call_back_to_your_app.your_application.com' } },
          payment_request_result: { id: 'cac95329-9fa5-42f1-a4fc-c08af7b868fb', resourceId: 'cdb5f11f-62df-e611-80ee-0aa34a9b2388', topic: 'payment_request',
                                    created_at: '2018-06-20T22:45:12.790Z', status: 'Success',
                                    event: { type: 'Payment Request',
                                             resource: { reference: 'KKPPLLMMNN', origination_time: '2017-01-20T22:45:12.790Z', sender_msisdn: '+2549703119050', amount: 'amount',
                                                         currency: 'KES', till_number: 'till_number', system: 'Lipa Na M-PESA', status: 'Received', sender_first_name: 'John',
                                                         sender_middle_name: 'O', sender_last_name: 'Doe' },
                                             errors: [] },
                                    metadata: { customer_id: 'customer_id', reference: 'reference', notes: 'Payment for invoice 123456' },
                                    _links: { self: 'https://api-sandbox.kopokopo.com/payment_requests/cac95329-9fa5-42f1-a4fc-c08af7b868fb',
                                              payment_request_result: 'https://api-sandbox.kopokopo.com/payment_request_results/cac95329-9fa5-42f1-a4fc-c08af7b868fb',
                                              resource: 'https://api-sandbox.kopokopo.com/buygoods_transaction/cdb5f11f-62df-e611-80ee-0aa34a9b2388' } } }
      # query_stk payment stub method
      mock_stub_request('get', 'payment_requests', request_body,200, return_response)

      expect { @k2stk.query_status(@query_input) }.not_to raise_error
    end
  end
end
