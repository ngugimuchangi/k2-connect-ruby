RSpec.describe K2ConnectRuby::K2Utilities::K2Authenticator do
  let(:k2_authenticator) { K2ConnectRuby::K2Utilities::K2Authenticator }

  describe '#authenticate' do
    let(:the_body) { HashWithIndifferentAccess.new(the_body: 'the_body') }
    it 'should raise an error if any of the parameters are empty' do
      expect { k2_authenticator.authenticate('', '', '') }.to raise_error ArgumentError
    end

    it 'should return a HMAC value and compare its value with the signature' do
      expect { k2_authenticator.authenticate('hello', 's', '7ac46bd3e055f611e1c8e08ee430e5ceee0526a853dad5353e3df9ebfb1b1701') }.not_to(raise_error)
    end

    it 'should raise an error if the HMAC is not equal to the signature' do
      expect { k2_authenticator.authenticate('Hello', 'secret', '1659863867f169b6a3ae49ca2deb95247267456505950a1a584c088d89b88c') }.to raise_error ArgumentError
    end
  end
end
