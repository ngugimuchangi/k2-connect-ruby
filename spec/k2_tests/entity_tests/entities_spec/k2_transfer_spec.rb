RSpec.describe K2Transfer do
  before(:all) do
    @k2transfer = K2Transfer.new("access_token")
    @k2transfer.extend(K2Validation)
  end

  it 'should include K2Validation Module and inherit from K2Entity' do
    expect(K2Transfer).to be < K2Entity
    expect(K2Transfer).to include(K2Validation)
  end

  context "Validation" do
    let(:params) { HashWithIndifferentAccess.new(first_name: "first_name" ,last_name: "last_name", phone: "phone", email: "email", currency:"currency", value:"value") }
    let(:array) { %w(first_name last_name phone email currency value) }
    it 'should validate user input' do
      expect(params).to be_a_kind_of(Hash)
      allow(@k2transfer).to receive(:validate_input).with(Hash, Array, false) { true }
      @k2transfer.validate_input(params, array, false)
      expect(@k2transfer).to have_received(:validate_input).with(Hash, Array, false)
      expect(@k2transfer.validate_input(params, array, false)).to eq(true)
    end
  end

  context "#settlement_account" do
    let(:params) { HashWithIndifferentAccess.new(account_name: "account_name" ,bank_ref: "bank_ref", bank_branch_ref: "bank_branch_ref", account_number: "account_number", currency:"currency", value:"value") }
    it 'should add pay recipient request' do
      allow(@k2transfer).to receive(:settlement_account).with(Hash) { {Location_url: "location_url"} }
      @k2transfer.settlement_account(params)
      expect(@k2transfer).to have_received(:settlement_account).with(Hash)
      expect(@k2transfer.settlement_account(params)).to eq({Location_url: "location_url"})
    end
  end

  context "#transfer_funds" do
    let(:params) { HashWithIndifferentAccess.new(currency: "currency" ,value: "value") }
    let(:destination) { "" }
    it 'should create transfer request' do
      if destination.nil? || destination == ""
        allow(@k2transfer).to receive(:transfer_funds).with("blind", Hash) { {Location_url: "location_url"} }
        @k2transfer.transfer_funds("blind", params)
        expect(@k2transfer).to have_received(:transfer_funds).with("blind", Hash)
        expect(@k2transfer.transfer_funds("blind", params)).to eq({Location_url: "location_url"})
      else
        allow(@k2transfer).to receive(:transfer_funds).with("targeted", Hash) { {Location_url: "location_url"} }
        @k2transfer.transfer_funds("targeted", params)
        expect(@k2transfer).to have_received(:transfer_funds).with("targeted", Hash)
        expect(@k2transfer.transfer_funds("targeted", params)).to eq({Location_url: "location_url"})
      end
    end
  end

  context "Query the status of a prior Transfer" do
    let(:params) { HashWithIndifferentAccess.new(id: "id") }
    it 'should query payment request status' do
      allow(@k2transfer).to receive(:query_transfer).with(Hash) { {response: "response"} }
      @k2transfer.query_transfer(params)
      expect(@k2transfer).to have_received(:query_transfer).with(Hash)
      expect(@k2transfer.query_transfer(params)).to eq({response: "response"})
    end
  end
end