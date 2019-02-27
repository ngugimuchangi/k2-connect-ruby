RSpec.describe K2Stk do
  include K2Validation
  let!(:stk) { double("STK") }
  let!(:valid) { double("Validation Module") }
  let!(:connection) { double("Connection Module") }

  it 'should include K2Validation Module' do
    expect(K2Stk).to include(K2Validation)
  end

  context "Receive payments from M-PESA users" do
    let(:params) { {first_name: "first_name" ,last_name: "last_name", phone: "phone", email: "email", currency:"currency", value:"value"} }
    let(:hash) { {path_url: "path_url" ,access_token: "access_token", is_get_request: false, is_subscription: false, params: params} }
    it 'should validate user input' do
      allow(valid).to receive(:validate_input).with(params) { true }
      allow(stk).to receive(:receive_mpesa_payments).with(params)
      expect(params).to be_a_kind_of(Hash)
      expect(hash[:is_get_request]).to eq(false)
      expect(hash[:is_subscription]).to eq(false)
      if valid.validate_input(params)
        expect(valid).to have_received(:validate_input).with(params)
        expect(valid.validate_input(params)).to eq(true)
        stk.receive_mpesa_payments(params)
        expect(stk).to have_received(:receive_mpesa_payments).with(params)
      end
    end

    it 'should add pay recipient request' do
      allow(stk).to receive(:receive_mpesa_payments).with(params)
      allow(connection).to receive(:to_connect).with(hash).and_return(Location_url: "location_url")
      if stk.receive_mpesa_payments(params)
        expect(stk).to have_received(:receive_mpesa_payments).with(params)
        connection.to_connect(hash)
        expect(connection).to have_received(:to_connect).with(hash)
        expect(connection.to_connect(hash)).to eq(Location_url: "location_url")
      end
    end
  end

  context "Query PAYment Request Status" do
    let(:params) { {id: "id" } }
    let(:hash) { {path_url: "path_url" ,access_token: "access_token", is_get_request: true, is_subscription: false, params: params} }
    it 'should validate user input' do
      allow(valid).to receive(:validate_input).with(params) { true }
      allow(stk).to receive(:query_mpesa_payments).with(params)
      expect(params).to be_a_kind_of(Hash)
      expect(hash[:is_get_request]).to eq(true)
      expect(hash[:is_subscription]).to eq(false)
      if valid.validate_input(params)
        expect(valid).to have_received(:validate_input).with(params)
        expect(valid.validate_input(params)).to eq(true)
        stk.query_mpesa_payments(params)
        expect(stk).to have_received(:query_mpesa_payments).with(params)
      end
    end

    it 'should query payment request status' do
      allow(stk).to receive(:query_mpesa_payments).with(params)
      allow(connection).to receive(:to_connect).with(hash).and_return(payment_request_result: "payment_request_result")
      if stk.query_mpesa_payments(params)
        expect(stk).to have_received(:query_mpesa_payments).with(params)
        connection.to_connect(hash)
        expect(connection).to have_received(:to_connect).with(hash)
        expect(connection.to_connect(hash)).to eq(Location_url: "location_url")
      end
    end
  end
end