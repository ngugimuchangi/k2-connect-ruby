RSpec.describe K2Transfer do
  include K2Validation
  let!(:transfer) { double("TRANSFER") }
  let!(:valid) { double("Validation Module") }
  let!(:connection) { double("Connection Module") }

  it 'should include K2Validation Module' do
    expect(K2Transfer).to include(K2Validation)
  end

  context "Create a Verified Settlement Account" do
    let(:params) { {account_name: "account_name" ,bank_ref: "bank_ref", bank_branch_ref: "bank_branch_ref", account_number: "account_number", currency:"currency", value:"value"} }
    let(:hash) { {path_url: "path_url" ,access_token: "access_token", is_get_request: false, is_subscription: false, params: params} }
    it 'should validate user input' do
      allow(valid).to receive(:validate_input).with(params) { true }
      allow(transfer).to receive(:settlement_account).with(params)
      expect(params).to be_a_kind_of(Hash)
      expect(hash[:is_get_request]).to eq(false)
      expect(hash[:is_subscription]).to eq(false)
      if valid.validate_input(params)
        expect(valid).to have_received(:validate_input).with(params)
        expect(valid.validate_input(params)).to eq(true)
        transfer.settlement_account(params)
        expect(transfer).to have_received(:settlement_account).with(params)
      end
    end

    it 'should add pay recipient request' do
      allow(transfer).to receive(:settlement_account).with(params)
      allow(connection).to receive(:to_connect).with(hash).and_return(Location_url: "location_url")
      if transfer.settlement_account(params)
        expect(transfer).to have_received(:settlement_account).with(params)
        connection.to_connect(hash)
        expect(connection).to have_received(:to_connect).with(hash)
        expect(connection.to_connect(hash)).to eq(Location_url: "location_url")
      end
    end
  end

  context "Create a Transfer" do
    let(:params) { {currency: "currency" ,value: "value"} }
    let(:hash) { {path_url: "path_url" ,access_token: "access_token", is_get_request: false, is_subscription: false, params: params} }
    it 'should validate user input' do
      allow(valid).to receive(:validate_input).with(params) { true }
      allow(transfer).to receive(:transfer_funds).with("destination", params)
      expect(params).to be_a_kind_of(Hash)
      expect(hash[:is_get_request]).to eq(false)
      expect(hash[:is_subscription]).to eq(false)
      if valid.validate_input(params)
        expect(valid).to have_received(:validate_input).with(params)
        expect(valid.validate_input(params)).to eq(true)
        transfer.transfer_funds("destination", params)
        expect(transfer).to have_received(:transfer_funds).with("destination", params)
      end
    end

    it 'should specify destination of transfer request' do
      destination = "targeted" || "blind"
      allow(transfer).to receive(:transfer_funds).with(destination, params)
      if destination.nil?
        transfer.transfer_funds("blind", params)
        expect(transfer).to have_received(:transfer_funds).with("blind", params)
      else
        transfer.transfer_funds("targeted", params)
        expect(transfer).to have_received(:transfer_funds).with("targeted", params)
      end
    end

    it 'should create transfer request' do
      allow(transfer).to receive(:transfer_funds).with("destination", params)
      allow(connection).to receive(:to_connect).with(hash).and_return(Location_url: "location_url")
      if transfer.transfer_funds("destination", params)
        expect(transfer).to have_received(:transfer_funds).with("destination", params)
        connection.to_connect(hash)
        expect(connection).to have_received(:to_connect).with(hash)
        expect(connection.to_connect(hash)).to eq(Location_url: "location_url")
      end
    end
  end

  context "Query the status of a prior Transfer" do
    let(:params) { {id: "id" } }
    let(:hash) { {path_url: "path_url" ,access_token: "access_token", is_get_request: true, is_subscription: false, params: params} }
    it 'should validate user input' do
      allow(valid).to receive(:validate_input).with(params) { true }
      allow(transfer).to receive(:query_transfer).with(params)
      expect(params).to be_a_kind_of(Hash)
      expect(hash[:is_get_request]).to eq(true)
      expect(hash[:is_subscription]).to eq(false)
      if valid.validate_input(params)
        expect(valid).to have_received(:validate_input).with(params)
        expect(valid.validate_input(params)).to eq(true)
        transfer.query_transfer(params)
        expect(transfer).to have_received(:query_transfer).with(params)
      end
    end

    it 'should query payment request status' do
      allow(transfer).to receive(:query_transfer).with(params)
      allow(connection).to receive(:to_connect).with(hash).and_return(payment_request_result: "payment_request_result")
      if transfer.query_transfer(params)
        expect(transfer).to have_received(:query_transfer).with(params)
        connection.to_connect(hash)
        expect(connection).to have_received(:to_connect).with(hash)
        expect(connection.to_connect(hash)).to eq(Location_url: "location_url")
      end
    end
  end
end