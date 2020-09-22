# TODO: If the simulation fails, it should not create an entry into the database
RSpec.describe K2Transfer do
  include SpecConfig, K2Validation
  before(:all) do
    @k2transfer = K2Transfer.new(K2AccessToken.new('ReMYAYdLKcg--XNmKhzkLNTIbXPvOUPs3hyycUF8WmI', '4707e306330759f4b63716f0525f6634a4685b4b4bf75b3381f1244ee77eb3fa').request_token)
    # blind transfer
    @blind_mobile_transfer_params = HashWithIndifferentAccess.new(destination_reference: '', destination_type: '', currency: 'currency', value: 'value', callback_url: 'https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3', metadata: { something: "Nice", extra: "Comments" })
    @blind_bank_transfer_params = HashWithIndifferentAccess.new(destination_reference: '', destination_type: '', currency: 'currency', value: 'value', callback_url: 'https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3', metadata: { something: "Nice", extra: "Comments" })

    # targeted transfer
    @mobile_transfer_params = HashWithIndifferentAccess.new(destination_reference: 'cbe4bcff-c453-49e1-a504-85b6845e4018', destination_type: 'merchant_wallet', currency: 'currency', value: 'value', callback_url: 'https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3', metadata: { something: "Nice", extra: "Comments" })
    @bank_transfer_params = HashWithIndifferentAccess.new(destination_reference: 'f2ccef92-196f-4762-a3f6-9d851c923aed', destination_type: 'merchant_bank_account', currency: 'currency', value: 'value', callback_url: 'https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3', metadata: { something: "Nice", extra: "Comments" })
  end

  describe '#transfer_funds' do
    context "blind transfer" do
      it 'should create a blind transfer request for a merchant_bank_account' do
        SpecConfig.custom_stub_request('post', K2Config.path_url('transfers'), @transfer_params, 200)
        expect { @k2transfer.transfer_funds(@blind_bank_transfer_params) }.not_to raise_error
        expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('transfers')))
      end

      it 'should create a blind transfer request for a merchant_wallet' do
        SpecConfig.custom_stub_request('post', K2Config.path_url('transfers'), @transfer_params, 200)
        expect { @k2transfer.transfer_funds(@blind_mobile_transfer_params) }.not_to raise_error
        expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('transfers')))
      end
    end


    context "targeted transfer" do
      it 'should create a transfer request to a merchant_bank_account' do
        SpecConfig.custom_stub_request('post', K2Config.path_url('transfers'), @bank_transfer_params, 200)
        expect { @k2transfer.transfer_funds(@bank_transfer_params) }.not_to raise_error
        expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('transfers')))
      end

      it 'should create a transfer request to a merchant_wallet' do
        SpecConfig.custom_stub_request('post', K2Config.path_url('transfers'), @mobile_transfer_params, 200)
        expect { @k2transfer.transfer_funds(@mobile_transfer_params) }.not_to raise_error
        expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('transfers')))
      end
    end
  end

  describe '#query_status' do
    it 'should query specified payment request status' do
      SpecConfig.custom_stub_request('get', K2Config.path_url('transfers'), '', 200)
      expect { @k2transfer.query_status }.not_to raise_error
      expect(@k2transfer.k2_response_body).not_to eq(nil)
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2transfer.location_url)))
    end
  end

  describe '#query_resource' do
    it 'should query specified payment request status' do
      SpecConfig.custom_stub_request('get', K2Config.path_url('transfers'), '', 200)
      expect { @k2transfer.query_resource(@k2transfer.location_url) }.not_to raise_error
      expect(@k2transfer.k2_response_body).not_to eq(nil)
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2transfer.location_url)))
    end
  end
end
