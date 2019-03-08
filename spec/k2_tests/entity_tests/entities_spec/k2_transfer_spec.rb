RSpec.describe K2Transfer do
  before(:all) do
    @k2transfer = K2Transfer.new("access_token")
    @k2transfer.extend(K2Validation)
  end

  it 'should include K2Validation Module and inherit from K2Entity' do
    expect(K2Transfer).to be < K2Entity
    expect(K2Transfer).to include(K2Validation)
  end

  context "#settlement_account" do
    let(:params) { HashWithIndifferentAccess.new(account_name: "account_name" ,bank_ref: "bank_ref", bank_branch_ref: "bank_branch_ref", account_number: "account_number", currency:"currency", value:"value") }
    let(:array) { %w{account_name bank_ref bank_branch_ref account_number currency value} }
    it '#validate_input' do
      expect{ @k2transfer.validate_input(params, array) }.not_to raise_error
    end

    it 'should add pay recipient request' do
      expect{ @k2transfer.settlement_account(params) }.not_to raise_error
    end
  end

  context "#transfer_funds" do
    let(:params) { HashWithIndifferentAccess.new(currency: "currency" ,value: "value") }
    let(:array) { %w{currency value} }
    it '#validate_input' do
      expect{ @k2transfer.validate_input(params, array) }.not_to raise_error
    end

    it 'should create a blind transfer request' do
      expect{ @k2transfer.transfer_funds(nil, params) }.not_to raise_error
    end

    it 'should create a targeted transfer request' do
      expect{ @k2transfer.transfer_funds("nil", params) }.not_to raise_error
    end
  end

  context "Query the status of a prior Transfer" do
    let(:params) { HashWithIndifferentAccess.new(id: "id") }
    let(:array) { %w{id} }
    it '#validate_input' do
      expect{ @k2transfer.validate_input(params, array) }.not_to raise_error
    end

    it 'should query payment request status' do
      expect{ @k2transfer.query_status(params) }.not_to raise_error
    end
  end
end