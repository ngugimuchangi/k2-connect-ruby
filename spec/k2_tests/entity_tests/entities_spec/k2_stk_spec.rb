require 'faker'

include K2ConnectRuby::K2Utilities::K2Validation
RSpec.describe K2ConnectRuby::K2Entity::K2Stk do
  before(:each) do
    stub_request(:post, 'https://sandbox.kopokopo.com/oauth/token').to_return(body: { access_token: "access_token" }.to_json, status: 200)
    @access_token = K2ConnectRuby::K2Entity::K2Token.new('client_id', 'client_secret').request_token
    @k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(@access_token)
    stub_request(:post, /sandbox.kopokopo.com/).to_return(status: 201, body: {data: "some_data"}.to_json, headers: { location: Faker::Internet.url })
  end

  before(:all) do
    @mpesa_payments = {
        payment_channel: 'M-PESA',
        till_number: 'K112233',
        first_name: 'first_name',
        last_name: 'last_name',
        phone_number: '0796230902',
        email: 'email@emailc.om',
        currency: 'currency',
        value: 1,
        metadata: {
            customer_id: 123_456_789,
            reference: 123_456,
            notes: 'Payment for invoice 12345'
        },
        callback_url: 'https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3'
    }
  end

  describe '#receive_mpesa_payments' do
    context "with valid details" do
      it 'sends an incoming payment request' do
        @k2_stk.receive_mpesa_payments(@mpesa_payments)
        expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('incoming_payments')))
      end

      it 'returns a location_url' do
        @k2_stk.receive_mpesa_payments(@mpesa_payments)
        expect(@k2_stk.location_url).not_to(eq(nil))
      end
    end

    context "with invalid details" do
      context "no phone number given" do
        it 'raises an error' do
          expect { @k2_stk.receive_mpesa_payments(@mpesa_payments.except(:phone_number)) }.to raise_error ArgumentError
        end
      end

      context "no till number given" do
        it 'raises an error' do
          expect { @k2_stk.receive_mpesa_payments(@mpesa_payments.except(:till_number)) }.to raise_error ArgumentError
        end
      end
    end
  end

  describe '#query_status' do
    it 'queries a recent payment request status' do
      @k2_stk.receive_mpesa_payments(@mpesa_payments)
      stub_request(:get, @k2_stk.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
      aggregate_failures do
        expect { @k2_stk.query_status }.not_to(raise_error)
        expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2_stk.location_url)))
      end
    end

    it 'returns a response body' do
      @k2_stk.receive_mpesa_payments(@mpesa_payments)
      stub_request(:get, @k2_stk.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
      @k2_stk.query_status
      expect(@k2_stk.k2_response_body).not_to(eq(nil))
    end
  end

  describe '#query_resource' do
    it 'queries a specified payment request status' do
      @k2_stk.receive_mpesa_payments(@mpesa_payments)
      stub_request(:get, @k2_stk.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
      aggregate_failures do
        expect { @k2_stk.query_resource(@k2_stk.location_url) }.not_to(raise_error)
        expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2_stk.location_url)))
      end
    end

    it 'returns a response body' do
      @k2_stk.receive_mpesa_payments(@mpesa_payments)
      stub_request(:get, @k2_stk.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
      @k2_stk.query_resource(@k2_stk.location_url)
      expect(@k2_stk.k2_response_body).not_to(eq(nil))
    end
  end
end
