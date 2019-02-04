RSpec.describe "K2Authorize" do
  let(:k2_auth) { K2ConnectRuby::K2Authorize.new }

  # Implicit receiver
  subject { k2_auth }

  it { should respond_to :authenticate? }

  it 'object should not be empty' do
    expect(k2_auth).not_to be nil
  end

  describe "#authenticate?" do
    context 'Nil Arguments' do
      body = nil
      api_secret_key = nil
      signature = nil
      it 'should raise error' do
        expect{ raise K2ConnectRuby::K2Errors::K2NilAuthArgument if body.nil? || api_secret_key.nil? || signature.nil? }.to raise_error(K2ConnectRuby::K2Errors::K2NilAuthArgument)
      end
    end

    context 'Proper Arguments' do
      it 'should create a digest' do
        expect(OpenSSL::Digest.new('sha256'))
      end

      it 'should create a hmac' do
        expect(OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), "#api_secret_key", "#body"))
      end

      it 'should return truth_value' do

      end
    end
  end

end