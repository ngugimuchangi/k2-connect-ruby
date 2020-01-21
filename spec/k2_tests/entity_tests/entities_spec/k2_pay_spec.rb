include K2Validation
RSpec.describe K2Pay do
  before(:all) do
    # K2Pay object
    @k2pay = K2Pay.new(K2AccessToken.new('BwuGu77i5M0SdCc9-R8haR3v0rIR5XsG4xYte27zxjs', '42aPhB6gF7u5n-r0-aL7fQkOVHAzoIYNPr4Nw-wCxQE').request_token)

    @create_request_body = { destination: "c7f300c0-f1ef-4151-9bbe-005005aa3747", amount: { currency: "KES", value: 20000 }, metadata: { customerId: "8675309", notes: "Salary payment for May 2018", something_else: "Something else" },
                             _links: { callback_url: "http://127.0.0.1:3003/payment_result" } }
    @pay_request_body = { type: "mobile_wallet", pay_recipient: { first_name: "John", last_name: "Doe", email: "johndoe@nomail.net", phone: "+254716230902", network: "Safaricom" } }
  end

  context '#pay_recipients' do
    it 'validates input correctly' do
      expect { validate_input(@pay_request_body, %w[type pay_recipient]) }.not_to raise_error
    end

    it 'should add pay recipient request' do
      SpecStubRequest.stub_request('post', K2Config.path_variable('pay_recipient'), @pay_request_body, 201)
      @k2pay.pay_recipients(@pay_request_body)
      expect(@k2pay.recipients_location_url).not_to eq(nil)
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.complete_url('pay_recipient')))
    end
  end

  context '#create_payment' do
    it 'validates input correctly' do
      expect { validate_input(@create_request_body, %w[destination amount metadata _links]) }.not_to raise_error
    end

    it 'should create outgoing payment request' do
      SpecStubRequest.stub_request('post', K2Config.path_variable('payments'), @create_request_body, 201)
      @k2pay.create_payment(@create_request_body)
      expect(@k2pay.payments_location_url).not_to eq(nil)
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.complete_url('payments')))
    end
  end

  context '#query_pay' do
    it 'should query adding pay recipients' do
      SpecStubRequest.stub_request('get', URI.parse(@k2pay.recipients_location_url).path, '', 200)
      @k2pay.query_status(@k2pay.recipients_location_url)
      expect(@k2pay.k2_response_body).not_to eq(nil)
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2pay.recipients_location_url)))
    end

    it 'should query creating payment request status' do
      skip "Does not return resource in the location_url from the API Sandbox"
      SpecStubRequest.stub_request('get', URI.parse(@k2pay.payments_location_url).path, @create_request_body, 200)
      @k2pay.query_status(@k2pay.payments_location_url)
      expect(@k2pay.k2_response_body).not_to eq(nil)
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2pay.payments_location_url)))
    end
  end
end
