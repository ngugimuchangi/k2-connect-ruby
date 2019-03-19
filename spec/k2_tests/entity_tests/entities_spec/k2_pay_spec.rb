RSpec.describe K2Pay do
  before(:all) do
    @k2pay = K2Pay.new('access_token')
    @k2pay.extend(K2Validation)
    @create_params = HashWithIndifferentAccess.new(currency: 'currency', value: 'value')
    @pay_params = HashWithIndifferentAccess.new(first_name: 'first_name', last_name: 'last_name', phone: '0716230902', email: 'email@email.com', network: 'network', pay_type: 'mobile_wallet', account_name: 'account_name', bank_id: 'bank_id', bank_branch_id: 'bank_branch_id', account_number: 'acc_no').merge(@create_params)
    @query_input = 'https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/payments'
  end

  it 'should include K2Validation Module and inherit from K2Entity' do
    expect(K2Pay).to be < K2Entity
    expect(K2Pay).to include(K2Validation)
  end

  context "#pay_recipients" do
    it 'validates input correctly' do
      expect { @k2pay.validate_input(@pay_params, %w{first_name last_name phone email network pay_type currency value account_name bank_id bank_branch_id account_number}) }.not_to raise_error
    end

    it 'should add pay recipient request' do
      expect { @k2pay.pay_recipients(@pay_params) }.not_to raise_error
    end
  end

  context "#create_payment" do
    it 'validates input correctly' do
      expect { @k2pay.validate_input(@create_params, %w(currency value)) }.not_to raise_error
    end

    it 'should create outgoing payment request' do
      expect { @k2pay.create_payment(@create_params) }.not_to raise_error
    end
  end

  context "#query_pay" do
    it 'validates query URL correctly' do
      expect { @k2pay.validate_url(@query_input) }.not_to raise_error
    end

    it 'should query payment request status' do
      expect { @k2pay.query_status(@query_input) }.not_to raise_error
    end
  end
end
