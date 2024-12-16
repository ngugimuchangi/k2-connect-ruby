require 'faker'

RSpec.describe K2ConnectRuby::K2Entity::K2Transfer do
  before(:each) do
    stub_request(:post, 'https://sandbox.kopokopo.com/oauth/token').to_return(body: { access_token: "access_token" }.to_json, status: 200)
    @access_token = K2ConnectRuby::K2Entity::K2Token.new('client_id', 'client_secret').request_token
    @k2_transfer =  K2ConnectRuby::K2Entity::K2Transfer.new(@access_token)
    stub_request(:post, /sandbox.kopokopo.com/).to_return(status: 201, body: {data: "some_data"}.to_json, headers: { location: Faker::Internet.url })
  end

  before(:all) do
    # blind transfer
    @blind_mobile_transfer_params = HashWithIndifferentAccess.new(destination_reference: '', destination_type: '', currency: 'currency', value: 'value', callback_url: 'https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3', metadata: { something: "Nice", extra: "Comments" })
    @blind_bank_transfer_params = HashWithIndifferentAccess.new(destination_reference: '', destination_type: '', currency: 'currency', value: 'value', callback_url: 'https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3', metadata: { something: "Nice", extra: "Comments" })

    # targeted transfer
    @mobile_transfer_params = HashWithIndifferentAccess.new(destination_reference: 'f624237a-d566-45a9-ab24-3650dac96553', destination_type: 'merchant_wallet', currency: 'currency', value: 'value', callback_url: 'https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3', metadata: { something: "Nice", extra: "Comments" })
    @bank_transfer_params = HashWithIndifferentAccess.new(destination_reference: 'ce5358da-72ec-4d11-b076-41ce5e794221', destination_type: 'merchant_bank_account', currency: 'currency', value: 'value', callback_url: 'https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3', metadata: { something: "Nice", extra: "Comments" })
  end

  describe '#transfer_funds' do
    context "blind transfer" do
      context 'merchant bank account' do
        it 'should create a blind transfer request for a merchant_bank_account' do
          aggregate_failures do
            expect { @k2_transfer.transfer_funds(@blind_bank_transfer_params) }.not_to(raise_error)
            expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('transfers')))
          end
        end

        it 'returns a location_url' do
          @k2_transfer.transfer_funds(@blind_bank_transfer_params)
          expect(@k2_transfer.location_url).not_to(eq(nil))
        end
      end

      context 'merchant wallet' do
        it 'should create a blind transfer request for a merchant_wallet' do
          aggregate_failures do
            expect { @k2_transfer.transfer_funds(@blind_mobile_transfer_params) }.not_to(raise_error)
            expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('transfers')))
          end
        end

        it 'returns a location_url' do
          @k2_transfer.transfer_funds(@blind_mobile_transfer_params)
          expect(@k2_transfer.location_url).not_to(eq(nil))
        end
      end
    end

    context "targeted transfer" do
      context 'merchant bank account' do
        it 'should create a transfer request to a merchant_bank_account' do
          aggregate_failures do
            expect { @k2_transfer.transfer_funds(@bank_transfer_params) }.not_to(raise_error)
            expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('transfers')))
          end
        end

        it 'returns a location_url' do
          @k2_transfer.transfer_funds(@bank_transfer_params)
          expect(@k2_transfer.location_url).not_to(eq(nil))
        end
      end

      context 'merchant wallet' do
        it 'should create a transfer request to a merchant_wallet' do
          aggregate_failures do
            expect { @k2_transfer.transfer_funds(@mobile_transfer_params) }.not_to(raise_error)
            expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('transfers')))
          end
        end

        it 'returns a location_url' do
          @k2_transfer.transfer_funds(@mobile_transfer_params)
          expect(@k2_transfer.location_url).not_to(eq(nil))
        end
      end
    end
  end

  describe '#query_status' do
    before(:each) do
      @k2_transfer.transfer_funds(@mobile_transfer_params)
      stub_request(:get, @k2_transfer.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
    end

    it 'should query recent payment/transfer request status' do
      aggregate_failures do
        expect { @k2_transfer.query_status }.not_to(raise_error)
        expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2_transfer.location_url)))
      end
    end

    it 'returns a response body' do
      @k2_transfer.query_resource(@k2_transfer.location_url)
      expect(@k2_transfer.k2_response_body).not_to(eq(nil))
    end
  end

  describe '#query_resource' do
    before(:each) do
      @k2_transfer.transfer_funds(@mobile_transfer_params)
      stub_request(:get, @k2_transfer.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
    end

    it 'should query specified payment/transfer request status' do
      aggregate_failures do
        expect { @k2_transfer.query_resource(@k2_transfer.location_url) }.not_to(raise_error)
        expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2_transfer.location_url)))
      end
    end

    it 'returns a response body' do
      @k2_transfer.query_resource(@k2_transfer.location_url)
      expect(@k2_transfer.k2_response_body).not_to(eq(nil))
    end
  end
end
