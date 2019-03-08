RSpec.describe K2Stk do
  before(:all) do
    @k2stk = K2Stk.new("access_token")
    @k2stk.extend(K2Validation)
  end

  it 'should include K2Validation Module and inherit from K2Entity' do
    expect(K2Stk).to be < K2Entity
    expect(K2Stk).to include(K2Validation)
  end

  context "#receive_mpesa_payments" do
    let(:params) { HashWithIndifferentAccess.new(first_name: "first_name" ,last_name: "last_name", phone: "phone", email: "email", currency:"currency", value:"value") }
    let(:array) { %w{first_name last_name phone email currency value} }
    it 'validates input correctly' do
      expect{ @k2stk.validate_input(params, array) }.not_to raise_error
    end

    it 'should add pay recipient request' do
      expect{ @k2stk.receive_mpesa_payments(params) }.not_to raise_error
    end
  end

  context "#query_mpesa_payments" do
    let(:params) { HashWithIndifferentAccess.new(id: "id") }
    let(:array) { %w{id} }
    it 'validates input correctly' do
      expect{ @k2stk.validate_input(params, array) }.not_to raise_error
    end

    it 'should query payment request status' do
      expect{ @k2stk.query_status(params) }.not_to raise_error
    end
  end
end