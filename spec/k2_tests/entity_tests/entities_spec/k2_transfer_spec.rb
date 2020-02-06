include SpecStubRequest, K2Validation
RSpec.describe K2Transfer do
  before(:all) do
    @k2transfer = K2Transfer.new(K2AccessToken.new('BwuGu77i5M0SdCc9-R8haR3v0rIR5XsG4xYte27zxjs', '42aPhB6gF7u5n-r0-aL7fQkOVHAzoIYNPr4Nw-wCxQE').request_token)

    @transfer_params = HashWithIndifferentAccess.new(currency: 'currency', value: 'value', callback_url: 'https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3')
    @mobile_settle_account = HashWithIndifferentAccess.new(type: 'mobile_wallet', msisdn: '254716230902', network: 'Safaricom')
    @bank_settle_account = HashWithIndifferentAccess.new(type: 'bank_account', account_name: 'account_name', bank_id: 'bank_id', bank_branch_id: 'bank_branch_id', account_number: 'account_number')
  end

  context '#settlement_account' do
    it 'should creating verified mobile wallet settlement account' do
      SpecStubRequest.stub_request('post', K2Config.path_variable('settlement_mobile_wallet'), @mobile_settle_account, 200)
      expect { @k2transfer.settlement_account(@mobile_settle_account) }.not_to raise_error
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.complete_url('settlement_mobile_wallet')))
    end

    it 'should creating verified bank settlement account' do
      SpecStubRequest.stub_request('post', K2Config.path_variable('settlement_bank_account'), @bank_settle_account, 200)
      expect { @k2transfer.settlement_account(@bank_settle_account) }.not_to raise_error
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.complete_url('settlement_bank_account')))
    end
  end

  context '#transfer_funds' do
    it 'should create a blind transfer request' do
      SpecStubRequest.stub_request('post', K2Config.path_variable('transfers'), @transfer_params, 200)
      expect { @k2transfer.transfer_funds(nil, @transfer_params) }.not_to raise_error
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.complete_url('transfers')))
    end

    it 'should create a targeted transfer request' do
      SpecStubRequest.stub_request('post', K2Config.path_variable('transfers'), @transfer_params, 200)
      expect { @k2transfer.transfer_funds('bb4e84a9-d944-42b1-a74a-e81ecec3576a', @transfer_params) }.not_to raise_error
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.complete_url('transfers')))
    end
  end

  context 'Query the status of a prior Transfer' do
    it 'should query creating verified settlement account status' do
      SpecStubRequest.stub_request('get', URI.parse(@k2transfer.settlement_location_url).path, '', 200)
      expect { @k2transfer.query_status(@k2transfer.settlement_location_url) }.not_to raise_error
      expect(@k2transfer.k2_response_body).not_to eq(nil)
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2transfer.settlement_location_url)))
    end

    it 'should query transfer status' do
      SpecStubRequest.stub_request('get', URI.parse(@k2transfer.transfer_location_url).path, '', 200)
      expect { @k2transfer.query_status(@k2transfer.transfer_location_url) }.not_to raise_error
      expect(@k2transfer.k2_response_body).not_to eq(nil)
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2transfer.transfer_location_url)))
    end
  end
end
