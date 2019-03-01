RSpec.describe K2Pay do
  before(:all) do
    @k2pay = K2Pay.new("access_token")
    @k2pay.extend(K2Validation)
  end

  it 'should include K2Validation Module and inherit from K2Entity' do
    expect(K2Pay).to be < K2Entity
    expect(K2Pay).to include(K2Validation)
  end

  context "Validation" do
    let(:params) { HashWithIndifferentAccess.new(first_name: "first_name" ,last_name: "last_name", phone: "phone", email: "email", currency:"currency", value:"value") }
    let(:array) { %w(first_name last_name phone email currency value) }
    it 'should validate user input' do
      expect(params).to be_a_kind_of(Hash)
      allow(@k2pay).to receive(:validate_input).with(Hash, Array, false) { true }
      @k2pay.validate_input(params, array, false)
      expect(@k2pay).to have_received(:validate_input).with(Hash, Array, false)
      expect(@k2pay.validate_input(params, array, false)).to eq(true)
    end
  end

  context "#pay_recipients" do
    let(:params) { HashWithIndifferentAccess.new(first_name: "first_name" ,last_name: "last_name", phone: "phone", email: "email", currency:"currency", value:"value") }
    it 'should add pay recipient request' do
      allow(@k2pay).to receive(:pay_recipients).with(Hash) { {Location_url: "location_url"} }
      @k2pay.pay_recipients(params)
      expect(@k2pay).to have_received(:pay_recipients).with(Hash)
      expect(@k2pay.pay_recipients(params)).to eq({Location_url: "location_url"})
    end
  end

  context "#pay_create" do
    let(:params) { HashWithIndifferentAccess.new(currency: "currency" ,value: "value") }
    it 'should create outgoing payment request' do
      allow(@k2pay).to receive(:pay_create).with(Hash) { {Location_url: "location_url"} }
      @k2pay.pay_create(params)
      expect(@k2pay).to have_received(:pay_create).with(Hash)
      expect(@k2pay.pay_create(params)).to eq({Location_url: "location_url"})
    end
  end

  context "#query_pay" do
    let(:params) { HashWithIndifferentAccess.new(id: "id") }
    it 'should query payment request status' do
      allow(@k2pay).to receive(:query_pay).with(Hash) { {status: "status"} }
      @k2pay.query_pay(params)
      expect(@k2pay).to have_received(:query_pay).with(Hash)
      expect(@k2pay.query_pay(params)).to eq({status: "status"})
    end
  end
end