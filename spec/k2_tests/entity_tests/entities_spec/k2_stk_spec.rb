RSpec.describe K2Stk do
  before(:all) do
    @k2stk = K2Stk.new("access_token")
    @k2stk.extend(K2Validation)
  end

  it 'should include K2Validation Module and inherit from K2Entity' do
    expect(K2Stk).to be < K2Entity
    expect(K2Stk).to include(K2Validation)
  end

  context "Validation" do
    let(:params) { {first_name: "first_name" ,last_name: "last_name", phone: "phone", email: "email", currency:"currency", value:"value"} }
    let(:array) { %w(first_name last_name phone email currency value) }
    it 'should validate user input' do
      expect(params).to be_a_kind_of(Hash)
      allow(@k2stk).to receive(:validate_input).with(Hash, Array, false) { true }
      @k2stk.validate_input(params, array, false)
      expect(@k2stk).to have_received(:validate_input).with(Hash, Array, false)
      expect(@k2stk.validate_input(params, array, false)).to eq(true)
    end
  end

  context "#receive_mpesa_payments" do
    let(:params) { {first_name: "first_name" ,last_name: "last_name", phone: "phone", email: "email", currency:"currency", value:"value"} }
    it 'should add pay recipient request' do
      allow(@k2stk).to receive(:receive_mpesa_payments).with(Hash) { {Location_url: "location_url"} }
      @k2stk.receive_mpesa_payments(params)
      expect(@k2stk).to have_received(:receive_mpesa_payments).with(Hash)
      expect(@k2stk.receive_mpesa_payments(params)).to eq({Location_url: "location_url"})
    end
  end

  context "#query_mpesa_payments" do
    let(:params) { {id: "id" } }
    it 'should query payment request status' do
      allow(@k2stk).to receive(:query_mpesa_payments).with(Hash) { {payment_request_result: "payment_request_result"} }
      @k2stk.query_mpesa_payments(params)
      expect(@k2stk).to have_received(:query_mpesa_payments).with(Hash)
      expect(@k2stk.query_mpesa_payments(params)).to eq({payment_request_result: "payment_request_result"})
    end
  end
end