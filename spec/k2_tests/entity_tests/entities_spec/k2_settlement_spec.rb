require 'faker'

RSpec.describe K2ConnectRuby::K2Entity::K2Settlement do
  before(:each) do
    stub_request(:post, 'https://sandbox.kopokopo.com/oauth/token').to_return(body: { access_token: "access_token" }.to_json, status: 200)
    @access_token = K2ConnectRuby::K2Entity::K2Token.new('client_id', 'client_secret').request_token
    @k2_settlement = K2ConnectRuby::K2Entity::K2Settlement.new(@access_token)
    stub_request(:post, /sandbox.kopokopo.com/).to_return(status: 201, body: {data: "some_data"}.to_json, headers: { location: Faker::Internet.url })
  end

  before(:all) do
    @mobile_settle_account = HashWithIndifferentAccess.new(type: 'merchant_wallet', first_name: 'first_name', last_name: 'last_name', phone_number: '254796230902', network: 'Safaricom')
    @bank_settle_account_eft = HashWithIndifferentAccess.new(type: 'merchant_bank_account', account_name: 'account_name', bank_branch_ref: '633aa26c-7b7c-4091-ae28-96c0687cf886', account_number: 'account_number', settlement_method: "EFT")
    @bank_settle_account_rts = HashWithIndifferentAccess.new(type: 'merchant_bank_account', account_name: 'account_name', bank_branch_ref: '633aa26c-7b7c-4091-ae28-96c0687cf886', account_number: 'account_number', settlement_method: "RTS")
  end

  context "Mobile Wallet settlement account" do
    describe "#add_settlement_account" do
      it 'should create verified mobile wallet settlement account' do
        aggregate_failures do
          expect { @k2_settlement.add_settlement_account(@mobile_settle_account) }.not_to(raise_error)
          expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('settlement_mobile_wallet')))
        end
      end
    end

    describe "#query_status" do
      it 'should query creating verified settlement account status' do
        @k2_settlement.add_settlement_account(@mobile_settle_account)
        stub_request(:get, @k2_settlement.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
        aggregate_failures do
          expect { @k2_settlement.query_status }.not_to(raise_error)
          expect(@k2_settlement.k2_response_body).not_to(eq(nil))
          expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2_settlement.location_url)))
        end
      end
    end

    describe "#query_resource" do
      it 'should query creating verified settlement account status' do
        @k2_settlement.add_settlement_account(@mobile_settle_account)
        stub_request(:get, @k2_settlement.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
        aggregate_failures do
          expect { @k2_settlement.query_resource(@k2_settlement.location_url) }.not_to(raise_error)
          expect(@k2_settlement.k2_response_body).not_to(eq(nil))
          expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2_settlement.location_url)))
        end
      end
    end
  end

  context "Bank Settlement Account" do
    describe " #add_settlement_account" do
      context "EFT settlement_method" do
        it 'should create verified bank settlement account' do
          aggregate_failures do
            expect { @k2_settlement.add_settlement_account(@bank_settle_account_eft) }.not_to(raise_error)
            expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('settlement_bank_account')))
          end
        end
      end

      context "RTS settlement_method" do
        it 'should create verified bank settlement account' do
          aggregate_failures do
            expect { @k2_settlement.add_settlement_account(@bank_settle_account_rts) }.not_to(raise_error)
            expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('settlement_bank_account')))
          end
        end
      end
    end

    describe "#query_status" do
      it 'should query transfer status' do
        @k2_settlement.add_settlement_account(@bank_settle_account_rts)
        stub_request(:get, @k2_settlement.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
        aggregate_failures do
          expect { @k2_settlement.query_status }.not_to(raise_error)
          expect(@k2_settlement.k2_response_body).not_to(eq(nil))
          expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2_settlement.location_url)))
        end
      end
    end

    describe "#query_resource" do
      it 'should query transfer status' do
        @k2_settlement.add_settlement_account(@bank_settle_account_rts)
        stub_request(:get, @k2_settlement.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
        aggregate_failures do
          expect { @k2_settlement.query_resource(@k2_settlement.location_url) }.not_to(raise_error)
          expect(@k2_settlement.k2_response_body).not_to(eq(nil))
          expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2_settlement.location_url)))
        end
      end
    end
  end
end
