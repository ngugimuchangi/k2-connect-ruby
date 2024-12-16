RSpec.describe K2ConnectRuby::K2Utilities::Config::K2Config do
  include K2ConnectRuby::K2Utilities::Config::K2Config
  let(:k2_config) { K2ConnectRuby::K2Utilities::Config::K2Config }

  describe '#set_base_url' do
    it 'should raise error if not a url' do
      expect { k2_config.set_base_url('url') }.to raise_error ArgumentError
    end

    it 'should set the url' do
      expect { k2_config.set_base_url('https://sandbox.kopokopo.com/') }.not_to(raise_error)
    end
  end

  context 'version number' do
    it 'should set the url' do
      expect { k2_config.set_version(1) }.not_to(raise_error)
      k2_config.set_version(1)
    end

    it 'should return the version' do
      expect { k2_config.version }.not_to(raise_error)
    end
  end

  context 'get all URLs set' do
    it 'should not retrieve Base URL' do
      expect { k2_config.base_url }.to raise_error NoMethodError
    end

    it 'should retrieve Path variable URL (Oauth Token)' do
      expect { k2_config.path_endpoint('oauth_token') }.not_to(raise_error)
    end

    it 'should retrieve Path variable URL (Webhooks)' do
      expect { k2_config.path_endpoint('webhook_subscriptions') }.not_to(raise_error)
    end

    it 'should retrieve Path variable URL (Outgoing payments)' do
      expect { k2_config.path_endpoint('pay_recipient') }.not_to(raise_error)
    end

    it 'should retrieve Path variable URL (STK Push)' do
      expect { k2_config.path_endpoint('incoming_payments') }.not_to(raise_error)
    end

    it 'should retrieve Path variable URL (Settlement Mobile Wallet)' do
      expect { k2_config.path_endpoint('settlement_mobile_wallet') }.not_to(raise_error)
    end

    it 'should retrieve Path variable URL (Settlement Bank Account)' do
      expect { k2_config.path_endpoint('settlement_bank_account') }.not_to(raise_error)
    end

    it 'should retrieve Path variable URL (Transfers)' do
      expect { k2_config.path_endpoint('transfers') }.not_to(raise_error)
    end

    it 'should retrieve all Path variable URLs' do
      expect { k2_config.path_endpoints }.not_to(raise_error)
    end

    it 'should retrieve whole Path variable URL (Oauth Token)' do
      expect { k2_config.path_url('oauth_token') }.not_to(raise_error)
    end
  end
end
