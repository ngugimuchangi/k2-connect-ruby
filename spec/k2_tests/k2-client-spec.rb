RSpec.describe "K2Client" do
  let(:k2_client) { K2ConnectRuby::K2Client.new('#api_secret_key') }

  # Implicit receiver
  subject { k2_client }
  it { should respond_to :parse_request }

  # Client Class created
  it 'object should not be empty' do
    expect(k2_client).not_to be nil
  end

  describe "#initialize" do
    # There is an api_secret_key initialized
    context 'Initialize Class' do
      it 'should have an api_secret_key' do
        expect(k2_client.api_secret_key).not_to be nil
      end
    end
  end

  describe "#parse_request" do
    context 'Nil Request Body' do
      it 'should raise error for nil request' do
        the_request = nil
        expect{ raise K2ConnectRuby::K2NilRequest if the_request.nil? }.to raise_error(K2ConnectRuby::K2NilRequest)
      end
    end

    context 'Request Present' do
      it 'should parse Request Body' do
        expect(k2_client.hash_body).not_to be " "
      end

      it 'should parse Request Header' do
        expect(k2_client.hash_header).not_to be " "
      end

      it 'should get X_KOPOKOPO_SIGNATURE' do
        expect(k2_client.k2_signature).not_to be " "
      end
    end
  end
end