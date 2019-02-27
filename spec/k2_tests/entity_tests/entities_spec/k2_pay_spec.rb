RSpec.describe K2Pay do
  include K2Validation
  let!(:pay) { double("PAY") }
  let!(:valid) { double("Validation Module") }
  let!(:connection) { double("Connection Module") }

  it 'should include K2Validation Module' do
    expect(K2Pay).to include(K2Validation)
  end

  context "Adding PAY recipients" do
    let(:params) { {first_name: "first_name" ,last_name: "last_name", phone: "phone", email: "email", currency:"currency", value:"value", etc: "etc"} }
    let(:hash) { {path_url: "path_url" ,access_token: "access_token", is_get_request: false, is_subscription: false, params: params} }
    it 'should validate user input' do
      allow(valid).to receive(:validate_input).with(params) { true }
      allow(pay).to receive(:pay_recipients).with(params)
      expect(params).to be_a_kind_of(Hash)
      expect(hash[:is_get_request]).to eq(false)
      expect(hash[:is_subscription]).to eq(false)
      if valid.validate_input(params)
        expect(valid).to have_received(:validate_input).with(params)
        expect(valid.validate_input(params)).to eq(true)
        pay.pay_recipients(params)
        expect(pay).to have_received(:pay_recipients).with(params)
      end
    end

    it 'should add pay recipient request' do
      allow(pay).to receive(:pay_recipients).with(params) { true }
      allow(connection).to receive(:to_connect).with(hash) { {Location_url: "location_url"} }
      if pay.pay_recipients(params)
        expect(pay).to have_received(:pay_recipients).with(params)
        connection.to_connect(hash)
        expect(connection).to have_received(:to_connect).with(hash)
        expect(connection.to_connect(hash)).to eq(Location_url: "location_url")
      end
    end
  end

  context "Create outgoing PAyment to Third Party" do
    let(:params) { {currency: "currency" ,value: "value"} }
    let(:hash) { {path_url: "path_url" ,access_token: "access_token", is_get_request: false, is_subscription: false, params: params} }
    it 'should validate user input' do
      allow(valid).to receive(:validate_input).with(params) { true }
      allow(pay).to receive(:pay_create).with(params)
      expect(params).to be_a_kind_of(Hash)
      expect(hash[:is_get_request]).to eq(false)
      expect(hash[:is_subscription]).to eq(false)
      if valid.validate_input(params)
        expect(valid).to have_received(:validate_input).with(params)
        expect(valid.validate_input(params)).to eq(true)
        pay.pay_create(params)
        expect(pay).to have_received(:pay_create).with(params)
      end
    end

    it 'should create outgoing payment request' do
      allow(pay).to receive(:pay_create).with(params) { true }
      allow(connection).to receive(:to_connect).with(hash) { {Location_url: "location_url"} }
      if pay.pay_create(params)
        expect(pay).to have_received(:pay_create).with(params)
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
      allow(pay).to receive(:query_pay).with(params) { true }
      expect(params).to be_a_kind_of(Hash)
      expect(hash[:is_get_request]).to eq(true)
      expect(hash[:is_subscription]).to eq(false)
      if valid.validate_input(params)
        expect(valid).to have_received(:validate_input).with(params)
        expect(valid.validate_input(params)).to eq(true)
        pay.query_pay(params)
        expect(pay).to have_received(:query_pay).with(params)
      end
    end

    it 'should query payment request status' do
      allow(pay).to receive(:query_pay).with(params) { true }
      allow(connection).to receive(:to_connect).with(hash) { {payment_request_result: "payment_request_result"} }
      if pay.query_pay(params)
        expect(pay).to have_received(:query_pay).with(params)
        connection.to_connect(hash)
        expect(connection).to have_received(:to_connect).with(hash)
        expect(connection.to_connect(hash)).to eq(payment_request_result: "payment_request_result")
      end
    end
  end
end