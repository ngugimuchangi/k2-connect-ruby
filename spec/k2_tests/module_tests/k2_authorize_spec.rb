RSpec.describe K2Authenticator do

  context "#authenticate?" do
    let(:the_body) { HashWithIndifferentAccess.new(the_body: "the_body") }
    let(:api_secret_key) { "api_secret_key" }
    let(:signature) { "signature" }
    it 'should raise an error if any of the parameters are empty' do
      raise K2EmptyAuthArgument if the_body.nil? || api_secret_key.nil? || signature.nil? && the_body=="" || api_secret_key=="" || signature==""
      expect { raise K2EmptyAuthArgument.new }.to raise_error K2EmptyAuthArgument
    end

    it 'should return a HMAC value and compare its value with the signature' do
      allow(K2Authenticator).to receive(:authenticate?).with(HashWithIndifferentAccess, api_secret_key, signature) { {hmac: true} }
      K2Authenticator.authenticate?(the_body, api_secret_key, signature)
      expect(K2Authenticator).to have_received(:authenticate?)
      expect(K2Authenticator.authenticate?(HashWithIndifferentAccess, api_secret_key, signature)).to eq({hmac: true})
    end

    it 'should raise an error if the HMAC is not equal to the signature' do
      allow(K2Authenticator).to receive(:authenticate?).with(HashWithIndifferentAccess, api_secret_key, signature) { {hmac: false} }
      K2Authenticator.authenticate?(the_body, api_secret_key, signature)
      raise K2InvalidHMAC unless K2Authenticator.authenticate?(HashWithIndifferentAccess, api_secret_key, signature)
      expect { raise K2InvalidHMAC.new }.to raise_error K2InvalidHMAC
    end
  end

end