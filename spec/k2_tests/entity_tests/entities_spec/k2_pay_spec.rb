include SpecStubRequest, K2Config, K2Validation
RSpec.describe K2Pay do
  before(:all) do
    @create_request_body = { destination: "c7f300c0-f1ef-4151-9bbe-005005aa3747", amount: { currency: "KES", value: 20000 }, metadata: { customerId: "8675309", notes: "Salary payment for May 2018", something_else: "Something else" },
                             _links: { callback_url: "http://127.0.0.1:3003/payment_result" } }
    @pay_request_body = { type: "mobile_wallet", pay_recipient: { first_name: "John", last_name: "Doe", email: "johndoe@nomail.net", phone: "+254716230902", network: "Safaricom" } }

    @query_create_pay_url = 'http://localhost:3000/api/v1/payments/'
    @query_pay_recipient_url = 'http://localhost:3000/api/v1/pay_recipients/9b4333bb-1f37-453a-b555-5924b5118a5b'

    @query_create_pay_response = { status: 'Scheduled', reference: 'KKKKKKKKK', origination_time: '2018-07-20T22:45:12.790Z', destination: 'c7f300c0-f1ef-4151-9bbe-005005aa3747',
                                   amount: { currency: 'KES', 'value': 20_000 }, metadata: { customerId: 8_675_309, notes: 'Salary payment for May 2018' },
                                   _links: { self: 'https://api-sandbox.kopokopo.com/payments/d76265cd-0951-e511-80da-0aa34a9b2388' } }
    @query_pay_recipient_response = { data: { id: "f8889531-c96f-4d2d-9f4e-ddb86f3a7acd", type: "pay_recipient",
                                             attributes: { recipient_type: "BankAccount", first_name: 'David', last_name: 'Mwangi', phone: "+254999999999", email: "johndoe@nomail.net", network: 'Safaricom', account_name: "John Bank", account_number: "123456789",
                                                           bank_id: "c7f300c0-f1ef-4151-9bbe-005005aa3747", bank_branch_id: "c7f300c0-f1ef-4151-9bbe-005005aa3747" } } }
  end

  context '#pay_recipients' do
    it 'validates input correctly' do
      expect { validate_input(@pay_request_body, %w[type pay_recipient]) }.not_to raise_error
    end

    it 'should add pay recipient request' do
      test_response = SpecStubRequest.mock_stub_request('post', K2Config.path_variable('pay_recipient'), @pay_request_body,201,
                                                        'http://localhost:3000/api/v1/pay_recipients/9b4333bb-1f37-453a-b555-5924b5118a5b')
      expect(Yajl::Parser.parse(test_response.header.to_json)["location"]).not_to eq(nil)
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.complete_url('pay_recipient')))
    end
  end

  context '#create_payment' do
    it 'validates input correctly' do
      expect { validate_input(@create_request_body, %w[destination amount metadata _links]) }.not_to raise_error
    end

    it 'should create outgoing payment request' do
      test_response = SpecStubRequest.mock_stub_request('post', K2Config.path_variable('payments'), @create_request_body,201,
                                                        'http://localhost:3000/api/v1/payments/9b4333bb-1f37-453a-b555-5924b5118a5b')
      expect(Yajl::Parser.parse(test_response.header.to_json)["location"]).not_to eq(nil)
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.complete_url('payments')))
    end
  end

  context '#query_pay' do
    pending("Not returning resource URL details in the location url of the result")
    it 'should query adding pay recipients' do
      test_response = SpecStubRequest.mock_stub_request('post', 'api/v1/pay_recipients/9b4333bb-1f37-453a-b555-5924b5118a5b', @create_request_body,200, nil, @query_pay_recipient_response)
      expect(Yajl::Parser.parse(test_response.header.to_json)["location"]).not_to eq(nil)
      expect(WebMock).to have_requested(:get, URI.parse('http://localhost:3000/api/v1/pay_recipients/9b4333bb-1f37-453a-b555-5924b5118a5b'))
    end

    it 'should query creating payment request status' do
      test_response = SpecStubRequest.mock_stub_request('get', 'api/v1/payments/', @create_request_body,200, nil, @query_create_pay_response)
      expect(Yajl::Parser.parse(test_response.body)).not_to eq(nil)
      expect(WebMock).to have_requested(:get, URI.parse('http://localhost:3000/api/v1/payments/'))
    end
  end
end
