include SpecConfig, K2Validation
RSpec.describe K2Settlement do
  before(:all) do
    @k2settlement = K2Settlement.new(K2AccessToken.new('KkcZEdj7qx7qfcFMyTWFaUXV7xZv8z8WIm72U06BiPI', 'mVoTlmrjsMw2mnfTXQrynz49ZcDX05Xp5wty-uNaZX8').request_token)

    @mobile_settle_account = HashWithIndifferentAccess.new(type: 'merchant_wallet', msisdn: '254716230902', network: 'Safaricom')
    @bank_settle_account = HashWithIndifferentAccess.new(type: 'merchant_bank_account', account_name: 'account_name', bank_id: 'bank_id', bank_branch_id: 'bank_branch_id', account_number: 'account_number')
  end

  context "Mobile Wallet settlement account" do
    describe "#add_settlement_account" do
      it 'should creating verified mobile wallet settlement account' do
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
    describe "#add_settlement_account" do
      it 'should creating verified bank settlement account' do
        SpecConfig.custom_stub_request('post', K2Config.path_url('settlement_bank_account'), @bank_settle_account, 200)
        expect { @k2settlement.add_settlement_account(@bank_settle_account) }.not_to raise_error
        expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('settlement_bank_account')))
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
