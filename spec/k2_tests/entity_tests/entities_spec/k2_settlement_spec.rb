include SpecConfig, K2Validation
RSpec.describe K2Settlement do
  before(:all) do
    @k2settlement = K2Settlement.new(K2AccessToken.new('ReMYAYdLKcg--XNmKhzkLNTIbXPvOUPs3hyycUF8WmI', '4707e306330759f4b63716f0525f6634a4685b4b4bf75b3381f1244ee77eb3fa').request_token)

    @mobile_settle_account = HashWithIndifferentAccess.new(type: 'merchant_wallet', first_name: 'first_name', last_name: 'last_name', phone_number: '254716230902', network: 'Safaricom')
    @bank_settle_account_eft = HashWithIndifferentAccess.new(type: 'merchant_bank_account', account_name: 'account_name', bank_branch_ref: '633aa26c-7b7c-4091-ae28-96c0687cf886', account_number: 'account_number', settlement_method: "EFT")
    @bank_settle_account_rts = HashWithIndifferentAccess.new(type: 'merchant_bank_account', account_name: 'account_name', bank_branch_ref: '633aa26c-7b7c-4091-ae28-96c0687cf886', account_number: 'account_number', settlement_method: "RTS")
  end

  context "Mobile Wallet settlement account" do
    describe "#add_settlement_account" do
      it 'should create verified mobile wallet settlement account' do
        SpecConfig.custom_stub_request('post', K2Config.path_url('settlement_mobile_wallet'), @mobile_settle_account, 200)
        expect { @k2settlement.add_settlement_account(@mobile_settle_account) }.not_to raise_error
        expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('settlement_mobile_wallet')))
      end
    end

    describe "#query_status" do
      it 'should query creating verified settlement account status' do
        SpecConfig.custom_stub_request('get', @k2settlement.location_url, '', 200)
        expect { @k2settlement.query_status }.not_to raise_error
        expect(@k2settlement.k2_response_body).not_to eq(nil)
        expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2settlement.location_url)))
      end
    end

    describe "#query_resource" do
      it 'should query creating verified settlement account status' do
        SpecConfig.custom_stub_request('get', @k2settlement.location_url, '', 200)
        expect { @k2settlement.query_resource(@k2settlement.location_url) }.not_to raise_error
        expect(@k2settlement.k2_response_body).not_to eq(nil)
        expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2settlement.location_url)))
      end
    end
  end

  context "Bank Settlement Account" do
    describe " #add_settlement_account" do
      context "EFT settlement_method" do
        it 'should create verified bank settlement account' do
          SpecConfig.custom_stub_request('post', K2Config.path_url('settlement_bank_account'), @bank_settle_account_eft, 200)
          expect { @k2settlement.add_settlement_account(@bank_settle_account_eft) }.not_to raise_error
          expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('settlement_bank_account')))
        end
      end

      context "RTS settlement_method" do
        it 'should create verified bank settlement account' do
          SpecConfig.custom_stub_request('post', K2Config.path_url('settlement_bank_account'), @bank_settle_account_rts, 200)
          expect { @k2settlement.add_settlement_account(@bank_settle_account_rts) }.not_to raise_error
          expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('settlement_bank_account')))
        end
      end
    end

    describe "#query_status" do
      it 'should query transfer status' do
        SpecConfig.custom_stub_request('get', @k2settlement.location_url, '', 200)
        expect { @k2settlement.query_status }.not_to raise_error
        expect(@k2settlement.k2_response_body).not_to eq(nil)
        expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2settlement.location_url)))
      end
    end

    describe "#query_resource" do
      it 'should query transfer status' do
        SpecConfig.custom_stub_request('get', @k2settlement.location_url, '', 200)
        expect { @k2settlement.query_resource(@k2settlement.location_url) }.not_to raise_error
        expect(@k2settlement.k2_response_body).not_to eq(nil)
        expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2settlement.location_url)))
      end
    end
  end
end
