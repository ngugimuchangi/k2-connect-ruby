include SpecConfig, K2Validation
RSpec.describe K2Settlement do
  before(:all) do
    @access_token = K2AccessToken.new('T1RyrPntqO4PJ35RLv6IVfPKRyg6gVoMvXEwEBin9Cw', 'Ywk_J18RySqLOmhhhVm8fhh4FzJTUzVcZJ03ckNpZK8').request_token
    @k2_polling = K2Settlement.new(@access_token)

    @mobile_settle_account = HashWithIndifferentAccess.new(type: 'merchant_wallet', first_name: 'first_name', last_name: 'last_name', phone_number: '254796230902', network: 'Safaricom')
    @bank_settle_account_eft = HashWithIndifferentAccess.new(type: 'merchant_bank_account', account_name: 'account_name', bank_branch_ref: '633aa26c-7b7c-4091-ae28-96c0687cf886', account_number: 'account_number', settlement_method: "EFT")
    @bank_settle_account_rts = HashWithIndifferentAccess.new(type: 'merchant_bank_account', account_name: 'account_name', bank_branch_ref: '633aa26c-7b7c-4091-ae28-96c0687cf886', account_number: 'account_number', settlement_method: "RTS")
  end

  context "Mobile Wallet settlement account" do
    describe "#add_settlement_account" do
      it 'should create verified mobile wallet settlement account' do
        SpecConfig.custom_stub_request('post', K2Config.path_url('settlement_mobile_wallet'), @mobile_settle_account, 200)
        expect { @k2_polling.add_settlement_account(@mobile_settle_account) }.not_to raise_error
        expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('settlement_mobile_wallet')))
      end
    end

    describe "#query_status" do
      it 'should query creating verified settlement account status' do
        SpecConfig.custom_stub_request('get', @k2_polling.location_url, '', 200)
        expect { @k2_polling.query_status }.not_to raise_error
        expect(@k2_polling.k2_response_body).not_to eq(nil)
        expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2_polling.location_url)))
      end
    end

    describe "#query_resource" do
      it 'should query creating verified settlement account status' do
        SpecConfig.custom_stub_request('get', @k2_polling.location_url, '', 200)
        expect { @k2_polling.query_resource(@k2_polling.location_url) }.not_to raise_error
        expect(@k2_polling.k2_response_body).not_to eq(nil)
        expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2_polling.location_url)))
      end
    end
  end

  context "Bank Settlement Account" do
    describe " #add_settlement_account" do
      context "EFT settlement_method" do
        it 'should create verified bank settlement account' do
          SpecConfig.custom_stub_request('post', K2Config.path_url('settlement_bank_account'), @bank_settle_account_eft, 200)
          expect { @k2_polling.add_settlement_account(@bank_settle_account_eft) }.not_to raise_error
          expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('settlement_bank_account')))
        end
      end

      context "RTS settlement_method" do
        it 'should create verified bank settlement account' do
          SpecConfig.custom_stub_request('post', K2Config.path_url('settlement_bank_account'), @bank_settle_account_rts, 200)
          expect { @k2_polling.add_settlement_account(@bank_settle_account_rts) }.not_to raise_error
          expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('settlement_bank_account')))
        end
      end
    end

    describe "#query_status" do
      it 'should query transfer status' do
        SpecConfig.custom_stub_request('get', @k2_polling.location_url, '', 200)
        expect { @k2_polling.query_status }.not_to raise_error
        expect(@k2_polling.k2_response_body).not_to eq(nil)
        expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2_polling.location_url)))
      end
    end

    describe "#query_resource" do
      it 'should query transfer status' do
        SpecConfig.custom_stub_request('get', @k2_polling.location_url, '', 200)
        expect { @k2_polling.query_resource(@k2_polling.location_url) }.not_to raise_error
        expect(@k2_polling.k2_response_body).not_to eq(nil)
        expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2_polling.location_url)))
      end
    end
  end
end
