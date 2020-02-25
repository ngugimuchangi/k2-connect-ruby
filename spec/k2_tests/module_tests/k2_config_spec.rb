# TODO: Add for newer Configuration commands
RSpec.describe K2Config do
  include K2Config
  describe '#set_base_url' do
    it 'should raise error if not a url' do
      expect { K2Config.set_base_url('url') }.to raise_error ArgumentError
    end
    it 'should set the url' do
      expect { K2Config.set_base_url('http://test.com') }.not_to raise_error
    end
  end

  describe '#set_callback_url' do
    it 'should raise error if not a url' do
      expect { K2Config.set_universal_callback_url('url') }.to raise_error ArgumentError
    end

    it 'should set the universal callback url' do
      expect { K2Config.set_universal_callback_url('http://test.com') }.not_to raise_error
    end

    it 'should set the webhook subscription url' do
      expect { K2Config.set_webhook_callback('http://test.com') }.not_to raise_error
    end

    it 'should set the payments callback url' do
      expect { K2Config.set_payments_callback('http://test.com') }.not_to raise_error
    end

    it 'should set the incoming payments callback url' do
      expect { K2Config.set_incoming_payments_callback('http://test.com') }.not_to raise_error
    end
  end

  context 'get all URLs set' do
    it 'should retrieve Base URL' do
      expect { K2Config.base_url }.not_to raise_error
    end

    it 'should retrieve Callback URL' do
      expect { K2Config.universal_callback_url }.not_to raise_error
    end

    it 'should retrieve Webhook Callback URL' do
      expect { K2Config.universal_callback_url }.not_to raise_error
    end

    it 'should retrieve Payments Callback URL' do
      expect { K2Config.universal_callback_url }.not_to raise_error
    end

    it 'should retrieve Incoming Payments Callback URL' do
      expect { K2Config.universal_callback_url }.not_to raise_error
    end

    it 'should retrieve Path variable URL (Oauth Token)' do
      expect { K2Config.path_variable('oauth_token') }.not_to raise_error
    end

    it 'should retrieve all Path variable URLs' do
      expect { K2Config.path_variables }.not_to raise_error
    end

    it 'should retrieve whole Path variable URL (Oauth Token)' do
      expect { K2Config.path_url('oauth_token') }.not_to raise_error
    end
  end
end
