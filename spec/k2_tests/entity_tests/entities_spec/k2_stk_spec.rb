include K2Validation
RSpec.describe K2Stk do
  before(:all) do
    @access_token = K2AccessToken.new('_9fXMGROLmSegBhofF6z-qDKHH5L6FsbMn2MgG24Xnk', 'nom1cCNLeFkVc4qafcBu2bGqGWTKv9WgS8YvZR3yaq8').request_token
    @k2stk = K2Stk.new(@access_token)

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
      it 'validates input correctly' do
        expect { validate_input(@mpesa_payments, %w[payment_channel till_number first_name last_name phone_number email currency value metadata callback_url]) }.not_to raise_error
      end

      it 'sends an incoming payment request' do
        SpecConfig.custom_stub_request('post', K2Config.path_url('incoming_payments'), @mpesa_payments, 200)
        @k2stk.receive_mpesa_payments(@mpesa_payments)
        expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('incoming_payments')))
      end

      it 'returns a location_url' do
        @k2stk.receive_mpesa_payments(@mpesa_payments)
        expect(@k2stk.location_url).not_to eq(nil)
      end
    end

    context "with invalid details" do
      context "no phone number given" do
        it 'raises an error' do
          expect { @k2stk.receive_mpesa_payments(@mpesa_payments.except(:phone_number)) }.to raise_error ArgumentError
        end
      end

      context "no till number given" do
        it 'raises an error' do
          expect { @k2stk.receive_mpesa_payments(@mpesa_payments.except(:till_number)) }.to raise_error ArgumentError
        end
      end
    end
  end

  describe '#query_status' do
    it 'queries a recent payment request status' do
      SpecConfig.custom_stub_request('get', K2Config.path_url('incoming_payments'), '', 200)
      expect { @k2stk.query_status }.not_to raise_error
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2stk.location_url)))
    end

    it 'returns a response body' do
      @k2stk.query_status
      expect(@k2stk.k2_response_body).not_to eq(nil)
    end
  end

  describe '#query_resource' do
    it 'queries a specified payment request status' do
      SpecConfig.custom_stub_request('get', K2Config.path_url('incoming_payments'), '', 200)
      expect { @k2stk.query_resource(@k2stk.location_url) }.not_to raise_error
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2stk.location_url)))
    end

    it 'returns a response body' do
      @k2stk.query_resource(@k2stk.location_url)
      expect(@k2stk.k2_response_body).not_to eq(nil)
    end
  end
end
