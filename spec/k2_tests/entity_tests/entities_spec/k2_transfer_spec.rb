RSpec.describe K2Transfer do
  before(:all) do
    @k2transfer = K2Transfer.new('access_token')
    @k2transfer.extend(K2Validation)
    @transfer_params = HashWithIndifferentAccess.new(currency: 'currency', value: 'value')
    @settle_params = HashWithIndifferentAccess.new(account_name: 'account_name', bank_ref: 'bank_ref', bank_branch_ref: 'bank_branch_ref', account_number: 'account_number').merge(@transfer_params)
    @query_input = 'https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/transfers'
  end

  it 'should include K2Validation Module and inherit from K2Entity' do
    expect(K2Transfer).to be < K2Entity
    expect(K2Transfer).to include(K2Validation)
  end

  context '#settlement_account' do
    let(:array) { %w[account_name bank_ref bank_branch_ref account_number currency value] }
    it 'validates input correctly' do
      expect { @k2transfer.validate_input(@settle_params, array) }.not_to raise_error
    end

    it 'should add pay recipient request' do
      # settlement_account stub method
      stub_request(:post, 'https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/merchant_bank_accounts')
          .with(body: { account_name: 'account_name', bank_ref: 'bank_ref', bank_branch_ref: 'bank_branch_ref', account_number: 'account_number' },
                headers: { 'Accept': %w(*/* application/json), 'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization': 'Bearer access_token',
                           'Connection': 'keep-alive', 'Content-Type': 'application/json', 'Keep-Alive': '30', 'User-Agent': 'Ruby' })
          .to_return(status: 200, body: {location: 'https://api-sandbox.kopokopo.com/merchant_bank_accounts/AB443D36-3757-44C1-A1B4-29727FB3111C"'}.to_json, headers: {})

      expect { @k2transfer.settlement_account(@settle_params) }.not_to raise_error
    end
  end

  context '#transfer_funds' do
    it 'validates input correctly' do
      expect { @k2transfer.validate_input(@transfer_params, %w[currency value]) }.not_to raise_error
    end

    it 'should create a blind transfer request' do
      # transfer_funds stub method
      stub_request(:post, 'https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/transfers')
          .with(body: { amount: { currency: 'currency', 'value': 'value'}, },
                headers: { 'Accept': %w(*/* application/json), 'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization': 'Bearer access_token',
                           'Connection': 'keep-alive', 'Content-Type': 'application/json', 'Keep-Alive': '30', 'User-Agent': 'Ruby' })
          .to_return(status: 200, body: {location: 'https://api-sandbox.kopokopo.com/pay_recipients/c7f300c0-f1ef-4151-9bbe-005005aa3747'}.to_json, headers: {})

      expect { @k2transfer.transfer_funds(nil, @transfer_params) }.not_to raise_error
    end

    it 'should create a targeted transfer request' do
      # transfer_funds stub method
      stub_request(:post, 'https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/transfers')
          .with(body: { amount: { currency: 'currency', 'value': 'value'}, destination: 'nil'},
                headers: { 'Accept': %w(*/* application/json), 'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization': 'Bearer access_token',
                           'Connection': 'keep-alive', 'Content-Type': 'application/json', 'Keep-Alive': '30', 'User-Agent': 'Ruby' })
          .to_return(status: 200, body: {location: 'https://api-sandbox.kopokopo.com/pay_recipients/c7f300c0-f1ef-4151-9bbe-005005aa3747'}.to_json, headers: {})

      expect { @k2transfer.transfer_funds('nil', @transfer_params) }.not_to raise_error
    end
  end

  context 'Query the status of a prior Transfer' do
    it 'validates query URL correctly' do
      expect { @k2transfer.validate_url(@query_input) }.not_to raise_error
    end

    it 'should query payment request status' do
      # query transfer stub method
      stub_request(:get, 'https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/transfers')
          .with(
              body: 'null',
              headers: { 'Accept': %w(*/* application/json), 'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization': 'Bearer access_token',
                         'Connection': 'keep-alive', 'Keep-Alive': '30', 'User-Agent': 'Ruby' })
          .to_return(status: 200, body:  { id: 'd76265cd-0951-e511-80da-0aa34a9b2388', status: 'Pending', initiated_at: '2018-05-02T00:30:25.580Z',
                                           amount: { 'value': 225.00, currency: 'KES' },
                                           _links: { self: 'https://api-sandbox.kopokopo.com/transfers/d76265cd-0951-e511-80da-0aa34a9b2388' } }.to_json, headers: {})

      expect { @k2transfer.query_status(@query_input) }.not_to raise_error
    end
  end
end
