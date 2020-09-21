RSpec.describe K2Authenticatorlast_name do
  describe '#authenticate' do
    let(:the_body) { HashWithIndifferentAccess.new(the_body: 'the_body') }
    it 'should raise an error if any of the parameters are empty' do
      expect { K2Authenticator.authenticate('', '', '') }.to raise_error ArgumentError
    end

    it 'should return a HMAC value and compare its value with the signature' do
      expect { K2Authenticator.authenticate('hello', 's', '7ac46bd3e055f611e1c8e08ee430e5ceee0526a853dad5353e3df9ebfb1b1701') }.not_to raise_error
    end

    it 'should raise an error if the HMAC is not equal to the signature' do
      expect { K2Authenticator.authenticate('Hello', 'secret', '1659863867f169b6a3ae49ca2deb95247267456505950a1a584c088d89b88c') }.to raise_error ArgumentError
    end
  end
end
