RSpec.describe K2Client do
  before(:all) do
    @k2client = K2Client.new('api_secret_key')
  end

  context '#initialize' do
    it 'should raise an error if api_secret_key parameter is empty' do
      expect { K2Client.new('') }.to raise_error ArgumentError
    end
  end

  context '#parse_request' do
    let(:the_request) { 'the_request' }
    it 'should raise an error if the_request parameter is empty' do
      expect { @k2client.parse_request('') }.to raise_error ArgumentError
    end

    it 'should parse the entire request' do
      allow(@k2client).to receive(:parse_request).with(the_request)
      expect { @k2client.parse_request(the_request) }.not_to raise_error
    end
  end
end
