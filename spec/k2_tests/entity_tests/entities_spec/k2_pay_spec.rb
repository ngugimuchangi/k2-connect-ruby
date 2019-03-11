RSpec.describe K2Pay do
  before(:all) do
    @k2pay = K2Pay.new("access_token")
    @k2pay.extend(K2Validation)
  end

  it 'should include K2Validation Module and inherit from K2Entity' do
    expect(K2Pay).to be < K2Entity
    expect(K2Pay).to include(K2Validation)
  end

  context "#pay_recipients" do
    let(:params) { HashWithIndifferentAccess.new(first_name: "first_name" ,last_name: "last_name", phone: "0716230902", email: "email@email.com", network: "network", pay_type: "mobile_wallet", currency:"currency", value:"value", account_name: "account_name", bank_id: "bank_id", bank_branch_id:"bank_branch_id", account_number:"acc_no") }
    let(:array) { %w{first_name last_name phone email network pay_type currency value account_name bank_id bank_branch_id account_number} }
    it 'validates input correctly' do
      expect{ @k2pay.validate_input(params, array) }.not_to raise_error
    end

    it 'should add pay recipient request' do
      expect{ @k2pay.pay_recipients(params) }.not_to raise_error
    end
  end

  context "#create_payment" do
    let(:params) { HashWithIndifferentAccess.new(currency: "currency" ,value: "value") }
    let(:array) { %w(currency value) }
    it 'validates input correctly' do
      expect{ @k2pay.validate_input(params, array) }.not_to raise_error
    end

    it 'should create outgoing payment request' do
      expect{ @k2pay.create_payment(params) }.not_to raise_error
    end
  end

  context "#query_pay" do
    let(:params) { HashWithIndifferentAccess.new(id: "id") }
    let(:array) { %w(id) }
    it 'validates input correctly' do
      expect{ @k2pay.validate_input(params, array) }.not_to raise_error
    end

    it 'should query payment request status' do
      expect{ @k2pay.query_status(params) }.not_to raise_error
    end
  end
end