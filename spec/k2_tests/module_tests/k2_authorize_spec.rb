RSpec.describe K2Authenticator do

  context "#authenticate?" do
    let(:the_body) { HashWithIndifferentAccess.new(the_body: "the_body") }
    let(:api_secret_key) { "api_secret_key" }
    let(:signature) { "signature" }
    it 'should raise an error if any of the parameters are empty' do
      expect { K2Authenticator.authenticate("","","") }.to raise_error ArgumentError
    end

    it 'should return a HMAC value and compare its value with the signature' do
      allow(K2Authenticator).to receive(:authenticate?).with(HashWithIndifferentAccess, api_secret_key, signature) { true }
      K2Authenticator.authenticate?(the_body, api_secret_key, signature)
      expect(K2Authenticator).to have_received(:authenticate?)
      expect(K2Authenticator.authenticate?(HashWithIndifferentAccess, api_secret_key, signature)).to eq(true)
    end

    it 'should raise an error if the HMAC is not equal to the signature' do
      expect { K2Authenticator.authenticate("Hello","secret","1659863867f169b6a3ae49ca2deb95247267456505950a1a584c088d89b88c") }.to raise_error ArgumentError
    end
  end

end