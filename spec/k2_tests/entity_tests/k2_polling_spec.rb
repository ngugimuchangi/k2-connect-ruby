include SpecConfig, K2Validation
RSpec.describe K2Polling do
  before(:all) do
    @access_token = K2AccessToken.new('T1RyrPntqO4PJ35RLv6IVfPKRyg6gVoMvXEwEBin9Cw', 'Ywk_J18RySqLOmhhhVm8fhh4FzJTUzVcZJ03ckNpZK8').request_token
    @k2_polling = K2Polling.new(@access_token)

    @till_polling_payload = HashWithIndifferentAccess.new(scope: 'till', scope_reference: 112233, from_time: Time.now - 14400, to_time: Time.now, callback_url: 'https://webhook.site/48d6113c-8967-4bf4-ab56-dcf470e0b005')
    @company_polling_payload = HashWithIndifferentAccess.new(scope: 'company', scope_reference: '', from_time: Time.now - 14400, to_time: Time.now, callback_url: 'https://webhook.site/48d6113c-8967-4bf4-ab56-dcf470e0b005')
  end

  context "Till scope" do
    describe "#poll" do
      it 'should create polling request' do
        SpecConfig.custom_stub_request('post', K2Config.path_url('poll'), @mobile_settle_account, 200)
        expect { @k2_polling.poll(@till_polling_payload) }.not_to raise_error
        expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('poll')))
      end

      it 'returns a location_url' do
        @k2_polling.poll(@till_polling_payload)
        expect(@k2_polling.location_url).not_to eq(nil)
      end
    end

    describe "#query_resource" do
      it 'should query creating verified settlement account status' do
        SpecConfig.custom_stub_request('get', @k2_polling.location_url, '', 200)
        expect { @k2_polling.query_resource }.not_to raise_error
        expect(@k2_polling.k2_response_body).not_to eq(nil)
        expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2_polling.location_url)))
      end
    end

    describe "#query_resource_url" do
      it 'should query creating verified settlement account status' do
        SpecConfig.custom_stub_request('get', @k2_polling.location_url, '', 200)
        expect { @k2_polling.query_resource_url(@k2_polling.location_url) }.not_to raise_error
        expect(@k2_polling.k2_response_body).not_to eq(nil)
        expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2_polling.location_url)))
      end
    end
  end

  context "Company scope" do
    describe "#poll" do
      it 'should create polling request' do
        SpecConfig.custom_stub_request('post', K2Config.path_url('poll'), @mobile_settle_account, 200)
        expect { @k2_polling.poll(@company_polling_payload) }.not_to raise_error
        expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('poll')))
      end

      it 'returns a location_url' do
        @k2_polling.poll(@company_polling_payload)
        expect(@k2_polling.location_url).not_to eq(nil)
      end
    end

    describe "#query_resource" do
      it 'should query creating verified settlement account status' do
        SpecConfig.custom_stub_request('get', @k2_polling.location_url, '', 200)
        expect { @k2_polling.query_resource }.not_to raise_error
        expect(@k2_polling.k2_response_body).not_to eq(nil)
        expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2_polling.location_url)))
      end
    end

    describe "#query_resource_url" do
      it 'should query creating verified settlement account status' do
        SpecConfig.custom_stub_request('get', @k2_polling.location_url, '', 200)
        expect { @k2_polling.query_resource_url(@k2_polling.location_url) }.not_to raise_error
        expect(@k2_polling.k2_response_body).not_to eq(nil)
        expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2_polling.location_url)))
      end
    end
  end
end
