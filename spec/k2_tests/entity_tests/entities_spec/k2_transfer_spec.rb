include SpecStubRequest, K2Validation
RSpec.describe K2Transfer do
  pending("Transfer yet to be set up on the Sandbox API")
  before(:all) do
    @transfer_params = HashWithIndifferentAccess.new(currency: 'currency', value: 'value')
    @settle_params = HashWithIndifferentAccess.new(account_name: 'account_name', bank_ref: 'bank_ref', bank_branch_ref: 'bank_branch_ref', account_number: 'account_number').merge(@transfer_params)
    @query_input = 'https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/transfers'
  end

  context '#settlement_account' do
    pending("Transfer settlement accounts")
    #let(:array) { %w[account_name bank_ref bank_branch_ref account_number currency value] }
    #it 'validates input correctly' do
    #  expect { @k2transfer.validate_input(@settle_params, array) }.not_to raise_error
    #end
    #
    #it 'should add pay recipient request' do
    #  # settlement_account stub components
    #        request_body = { account_name: 'account_name', bank_ref: 'bank_ref', bank_branch_ref: 'bank_branch_ref', account_number: 'account_number' }
    #        return_response = { location: 'https://api-sandbox.kopokopo.com/merchant_bank_accounts/AB443D36-3757-44C1-A1B4-29727FB3111C' }
    #        # receive_mpesa_payments stub method
    #        mock_stub_request('post', 'merchant_bank_accounts', request_body,200, return_response)
    #
    #  expect { @k2transfer.settlement_account(@settle_params) }.not_to raise_error
    #end
  end

  context '#transfer_funds' do
    pending('transferring of funds')
    #it 'validates input correctly' do
    #  expect { @k2transfer.validate_input(@transfer_params, %w[currency value]) }.not_to raise_error
    #end
    #
    #it 'should create a blind transfer request' do
    #  # transfer_funds stub components
    #  request_body = { amount: { currency: 'currency', 'value': 'value'} }
    #  return_response = { location: 'https://api-sandbox.kopokopo.com/pay_recipients/c7f300c0-f1ef-4151-9bbe-005005aa3747' }
    #  # transfer_funds stub method
    #  mock_stub_request('post', 'transfers', request_body,200, return_response)
    #
    #  expect { @k2transfer.transfer_funds(nil, @transfer_params) }.not_to raise_error
    #end
    #
    #it 'should create a targeted transfer request' do
    #  # transfer_funds stub components
    #  request_body = { amount: { currency: 'currency', 'value': 'value'}, destination: 'nil'}
    #  return_response = { location: 'https://api-sandbox.kopokopo.com/pay_recipients/c7f300c0-f1ef-4151-9bbe-005005aa3747' }
    #  # transfer_funds stub method
    #  mock_stub_request('post', 'transfers', request_body,200, return_response)
    #
    #  expect { @k2transfer.transfer_funds('nil', @transfer_params) }.not_to raise_error
    #end
  end

  context 'Query the status of a prior Transfer' do
    pending('Query the status of a prior Transfer')
    #it 'validates query URL correctly' do
    #  expect { @k2transfer.validate_url(@query_input) }.not_to raise_error
    #end
    #
    #it 'should query payment request status' do
    #   query transfer stub components
    #  request_body = 'null'
    #  return_response = { id: 'd76265cd-0951-e511-80da-0aa34a9b2388', status: 'Pending', initiated_at: '2018-05-02T00:30:25.580Z',
    #                      amount: { 'value': 225.00, currency: 'KES' },
    #                      _links: { self: 'https://api-sandbox.kopokopo.com/transfers/d76265cd-0951-e511-80da-0aa34a9b2388' } }
    #  # transfer_funds stub method
    #  mock_stub_request('get', 'transfers', request_body,200, return_response)
    #
    #  expect { @k2transfer.query_status(@query_input) }.not_to raise_error
    #end
  end
end
