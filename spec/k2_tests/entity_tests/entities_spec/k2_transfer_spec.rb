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

  context "#settlement_account" do
    let(:array) { %w{account_name bank_ref bank_branch_ref account_number currency value} }
    it 'validates input correctly' do
      expect { @k2transfer.validate_input(@settle_params, array) }.not_to raise_error
    end

    it 'should add pay recipient request' do
      expect { @k2transfer.settlement_account(@settle_params) }.not_to raise_error
    end
  end

  context "#transfer_funds" do
    it 'validates input correctly' do
      expect { @k2transfer.validate_input(@transfer_params, %w{currency value}) }.not_to raise_error
    end

    it 'should create a blind transfer request' do
      expect { @k2transfer.transfer_funds(nil, @transfer_params) }.not_to raise_error
    end

    it 'should create a targeted transfer request' do
      expect { @k2transfer.transfer_funds("nil", @transfer_params) }.not_to raise_error
    end
  end

  context "Query the status of a prior Transfer" do
    it 'validates query URL correctly' do
      expect { @k2transfer.validate_url(@query_input) }.not_to raise_error
    end

    it 'should query payment request status' do
      expect { @k2transfer.query_status(@query_input) }.not_to raise_error
    end
  end
end
