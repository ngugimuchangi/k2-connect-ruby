RSpec.describe K2Stk do
  before(:all) do
    @k2stk = K2Stk.new("access_token")
    @k2stk.extend(K2Validation)
    @mpesa_payments = HashWithIndifferentAccess.new(first_name: "first_name", last_name: "last_name", phone: "0716230902", email: "email@emailc.om", currency: "currency", value: "value")
    @mpesa_payments_hash = {first_name: "first_name", last_name: "last_name", phone: "0716230902", email: "email@emailc.om", currency: "currency", value: "value"}
    @query_status = HashWithIndifferentAccess.new(id: "id")
  end

  it 'should include K2Validation Module and inherit from K2Entity' do
    expect(K2Stk).to be < K2Entity
    expect(K2Stk).to include(K2Validation)
  end

  context "#receive_mpesa_payments" do
    it 'validates input correctly' do
      expect { @k2stk.validate_input(@mpesa_payments_hash, %w{first_name last_name phone email currency value}) }.not_to raise_error
    end

    it 'should add pay recipient request' do
      expect { @k2stk.receive_mpesa_payments(@mpesa_payments_hash) }.not_to raise_error
    end
  end

  context "#query_status" do
    it 'validates input correctly' do
      expect { @k2stk.validate_input(@query_status, %w{id}) }.not_to raise_error
    end

    it 'should query payment request status' do
      expect { @k2stk.query_status(@query_status) }.not_to raise_error
    end
  end
end
