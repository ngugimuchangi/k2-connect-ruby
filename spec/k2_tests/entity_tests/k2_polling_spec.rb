require 'faker'

RSpec.describe K2ConnectRuby::K2Entity::K2Polling do
  before(:all) do
    @till_polling_payload = HashWithIndifferentAccess.new(scope: 'till', scope_reference: 112233, from_time: Time.now - 14400, to_time: Time.now, callback_url: 'https://webhook.site/48d6113c-8967-4bf4-ab56-dcf470e0b005')
    @company_polling_payload = HashWithIndifferentAccess.new(scope: 'company', scope_reference: '', from_time: Time.now - 14400, to_time: Time.now, callback_url: 'https://webhook.site/48d6113c-8967-4bf4-ab56-dcf470e0b005')
  end

  before(:each) do
    stub_request(:post, 'https://sandbox.kopokopo.com/oauth/token').to_return(body: { access_token: "access_token" }.to_json, status: 200)
    @access_token = K2ConnectRuby::K2Entity::K2Token.new('client_id', 'client_secret').request_token
    @k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(@access_token)
    stub_request(:post, /sandbox.kopokopo.com/).to_return(status: 201, body: {data: "some_data"}.to_json, headers: { location: Faker::Internet.url })
  end

  context "Till scope" do
    describe "#poll" do
      it 'should create polling request' do
        aggregate_failures do
          expect { @k2_polling.poll(@till_polling_payload) }.not_to(raise_error)
          expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('poll')))
        end
      end

      it 'returns a location_url' do
        @k2_polling.poll(@till_polling_payload)
        expect(@k2_polling.location_url).not_to(eq(nil))
      end
    end

    describe "#query_resource" do
      it 'should query creating verified settlement account status' do
        @k2_polling.poll(@till_polling_payload)
        stub_request(:get, @k2_polling.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
        aggregate_failures do
          expect { @k2_polling.query_resource }.not_to(raise_error)
          expect(@k2_polling.k2_response_body).not_to(eq(nil))
          expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2_polling.location_url)))
        end
      end
    end

    describe "#query_resource_url" do
      it 'should query creating verified settlement account status' do
        @k2_polling.poll(@till_polling_payload)
        stub_request(:get, @k2_polling.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
        aggregate_failures do
          expect { @k2_polling.query_resource_url(@k2_polling.location_url) }.not_to(raise_error)
          expect(@k2_polling.k2_response_body).not_to(eq(nil))
          expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2_polling.location_url)))
        end
      end
    end
  end

  context "Company scope" do
    describe "#poll" do
      it 'should create polling request' do
        aggregate_failures do
          expect { @k2_polling.poll(@company_polling_payload) }.not_to(raise_error)
          expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('poll')))
        end
      end

      it 'returns a location_url' do
        @k2_polling.poll(@company_polling_payload)
        expect(@k2_polling.location_url).not_to(eq(nil))
      end
    end

    describe "#query_resource" do
      it 'should query creating verified settlement account status' do
        @k2_polling.poll(@company_polling_payload)
        stub_request(:get, @k2_polling.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
        aggregate_failures do
          expect { @k2_polling.query_resource }.not_to(raise_error)
          expect(@k2_polling.k2_response_body).not_to(eq(nil))
          expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2_polling.location_url)))
        end
      end
    end

    describe "#query_resource_url" do
      it 'should query creating verified settlement account status' do
        @k2_polling.poll(@company_polling_payload)
        stub_request(:get, @k2_polling.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
        aggregate_failures do
          expect { @k2_polling.query_resource_url(@k2_polling.location_url) }.not_to(raise_error)
          expect(@k2_polling.k2_response_body).not_to(eq(nil))
          expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2_polling.location_url)))
        end
      end
    end
  end
end
