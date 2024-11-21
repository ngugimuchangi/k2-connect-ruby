require 'faker'

include K2ConnectRuby::K2Utilities::K2Validation
RSpec.describe K2ConnectRuby::K2Entity::K2Pay do
  before(:each) do
    stub_request(:post, 'https://sandbox.kopokopo.com/oauth/token').to_return(body: { access_token: "access_token" }.to_json, status: 200)
    @access_token = K2ConnectRuby::K2Entity::K2Token.new('client_id', 'client_secret').request_token
    @k2pay = K2ConnectRuby::K2Entity::K2Pay.new(@access_token)
  end

  before(:all) do
    @mobile_wallet_payment = { destination_reference: "9764ef5f-fcd6-42c1-bbff-de280becc64b", destination_type: "mobile_wallet", currency: "KES", value: 20000, description: "k2-connect", category: "general", tags: %w[tag_1 tag_2], callback_url: "https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3", metadata: { customerId: '8_675_309', notes: 'Salary payment for May 2018' } }
    @bank_account_payment = {  destination_reference: "c533cb60-8501-440d-8150-7eaaff84616a", destination_type: "bank_account", currency: "KES", value: 20000, description: "k2-connect", category: "general", tags: %w[tag_1 tag_2], callback_url: "https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3", metadata: { customerId: '8_675_309', notes: 'Salary payment for May 2018' } }
    @paybill_payment = {  destination_reference: "a59950cc-d171-457b-9671-9915b0787f49", destination_type: "paybill", currency: "KES", value: 20000, description: "k2-connect", category: "general", tags: %w[tag_1 tag_2], callback_url: "https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3", metadata: { customerId: '8_675_309', notes: 'Salary payment for May 2018' } }
    @till_payment = {  destination_reference: "7d08c521-f44a-40c1-87cf-eb8eaa014152", destination_type: "till", currency: "KES", value: 20000, description: "k2-connect", category: "general", tags: %w[tag_1 tag_2], callback_url: "https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3", metadata: { customerId: '8_675_309', notes: 'Salary payment for May 2018' } }

    @mobile_pay_request_body = { type: "mobile_wallet", first_name: "John", last_name: "Doe", email: "johndoe@nomail.net", phone_number: "+254796230902", network: "Safaricom" }
    @bank_pay_request_body_eft = { type: "bank_account", account_name: "David Kariuki", account_number: 566566, bank_branch_ref: "633aa26c-7b7c-4091-ae28-96c0687cf886", settlement_method: 'EFT' }
    @bank_pay_request_body_rts = { type: "bank_account", account_name: "David Kariuki", account_number: 566566, bank_branch_ref: "633aa26c-7b7c-4091-ae28-96c0687cf886", settlement_method: 'RTS' }
    @till_pay_request_body = { type: "till", till_name: "John Doe", till_number: "098098" }
    @paybill_pay_request_body = { type: "paybill", paybill_name: "Test Paybill 1", paybill_number: "559123", paybill_account_number: "dynamite_1" }

    @incorrect_network = { type: "mobile_wallet", first_name: "John", last_name: "Doe", email: "johndoe@nomail.net", phone_number: "+254796230902", network: "Safarm" }
    @wrong_bank_pay_request_body = { type: "bank_account", first_name: "John", last_name: "Doe", email: "johndoe@nomail.net", phone_number: "+254796230902", account_name: "David Kariuki", account_number: 566566, bank_ref: 21, bank_branch_ref: "633aa26c-7b7c-4091-ae28-96c0687cf886", settlement_method: 'RTI' }
  end

  describe '#add_recipients' do
    before(:each) do
      stub_request(:post, 'https://sandbox.kopokopo.com/api/v1/pay_recipients')
        .to_return(status: 201, body: {data: "some_data"}.to_json, headers: { location: Faker::Internet.url })
    end

    context "Adding a Mobile PAY Recipient" do
      context "Correct recipient details" do
        it 'should send an add mobile wallet pay recipient request' do
          @k2pay.add_recipient(@mobile_pay_request_body)
          expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('pay_recipient')))
        end

        it 'returns a location_url' do
          @k2pay.add_recipient(@mobile_pay_request_body)
          expect(@k2pay.recipients_location_url).not_to(eq(nil))
        end
      end

      context "Wrong recipient details" do
        it 'should not send an add mobile wallet pay recipient request' do
          aggregate_failures do
            expect { @k2pay.add_recipient(@incorrect_network) }.to raise_error ArgumentError
            expect(WebMock).not_to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('pay_recipient')))
          end
        end
      end
    end

    context "Adding a Bank PAY Recipient" do
      context "Correct recipient details" do
        context "EFT settlement_method" do
          it 'should send an add bank account pay recipient request' do
            @k2pay.add_recipient(@bank_pay_request_body_eft)
            expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('pay_recipient')))
          end

          it 'returns a location_url' do
            @k2pay.add_recipient(@bank_pay_request_body_eft)
            expect(@k2pay.recipients_location_url).not_to(eq(nil))
          end
        end

        context "RTS settlement_method" do
          it 'should send an add bank account pay recipient request' do
            @k2pay.add_recipient(@bank_pay_request_body_rts)
            expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('pay_recipient')))
          end

          it 'returns a location_url' do
            @k2pay.add_recipient(@bank_pay_request_body_rts)
            expect(@k2pay.recipients_location_url).not_to(eq(nil))
          end
        end
      end

      context "Wrong recipient details" do
        context "Wrong settlment method" do
          it 'should not send an add bank account pay recipient request' do
            aggregate_failures do
              expect { @k2pay.add_recipient(@wrong_bank_pay_request_body) }.to raise_error ArgumentError
              expect(WebMock).not_to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('pay_recipient')))
            end
          end
        end
      end
    end

    context "Adding a Till PAY Recipient" do
      context "Correct recipient details" do
        it 'should send an add till pay recipient request' do
          @k2pay.add_recipient(@till_pay_request_body)
          expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('pay_recipient')))
        end

        it 'returns a location_url' do
          @k2pay.add_recipient(@till_pay_request_body)
          expect(@k2pay.recipients_location_url).not_to(eq(nil))
        end
      end
    end

    context "Adding a Paybill PAY Recipient" do
      context "Correct recipient details" do
        it 'should send an add paybill pay recipient request' do
          @k2pay.add_recipient(@paybill_pay_request_body)
          expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('pay_recipient')))
        end

        it 'returns a location_url' do
          @k2pay.add_recipient(@paybill_pay_request_body)
          expect(@k2pay.recipients_location_url).not_to(eq(nil))
        end
      end
    end
  end

  describe ' #create_payment' do
    before(:each) do
      stub_request(:post, 'https://sandbox.kopokopo.com/api/v1/payments')
        .to_return(status: 201, body: {data: "some_data"}.to_json, headers: { location: Faker::Internet.url })
    end

    context 'mobile_wallet destination_type' do
      it 'should create outgoing payment request' do
        @k2pay.create_payment(@mobile_wallet_payment)
        expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('payments')))
      end

      it 'should create a payment location_url' do
        @k2pay.create_payment(@mobile_wallet_payment)
        expect(@k2pay.payments_location_url).not_to(eq(nil))
      end
    end

    context 'bank_account destination_type' do
      it 'should create outgoing payment request' do
        @k2pay.create_payment(@bank_account_payment)
        expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('payments')))
      end

      it 'should create a payment location_url' do
        @k2pay.create_payment(@bank_account_payment)
        expect(@k2pay.payments_location_url).not_to(eq(nil))
      end
    end

    context 'till destination_type' do
      it 'should create outgoing payment request' do
        @k2pay.create_payment(@till_payment)
        expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('payments')))
      end

      it 'should create a payment location_url' do
        @k2pay.create_payment(@till_payment)
        expect(@k2pay.payments_location_url).not_to(eq(nil))
      end
    end

    context 'paybill destination_type' do
      it 'should create outgoing payment request' do
        @k2pay.create_payment(@paybill_payment)
        expect(WebMock).to have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('payments')))
      end

      it 'should create a payment location_url' do
        @k2pay.create_payment(@paybill_payment)
        expect(@k2pay.payments_location_url).not_to(eq(nil))
      end
    end
  end

  describe '#query_status' do
    context 'for adding pay recipients' do
      before(:each) do
        stub_request(:post, 'https://sandbox.kopokopo.com/api/v1/pay_recipients')
          .to_return(status: 201, body: {data: "some_data"}.to_json, headers: { location: Faker::Internet.url })
        @k2pay.add_recipient(@mobile_pay_request_body)
        stub_request(:get, @k2pay.recipients_location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
      end

      it 'should query adding pay recipients' do
        aggregate_failures do
          expect { @k2pay.query_status('recipients') }.not_to(raise_error)
          expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2pay.recipients_location_url)))
        end
      end

      it 'returns a response body' do
        @k2pay.query_status('recipients')
        expect(@k2pay.k2_response_body).not_to(eq(nil))
      end
    end

    context 'for creating payments' do
      before(:each) do
        stub_request(:post, 'https://sandbox.kopokopo.com/api/v1/payments')
          .to_return(status: 201, body: {data: "some_data"}.to_json, headers: { location: Faker::Internet.url })
        @k2pay.create_payment(@paybill_payment)
        stub_request(:get, @k2pay.payments_location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
      end

      it 'should query creating payment request status' do
        aggregate_failures do
          expect { @k2pay.query_status('payments') }.not_to(raise_error)
          expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2pay.payments_location_url)))
        end
      end

      it 'returns a response body' do
        @k2pay.query_status('payments')
        expect(@k2pay.k2_response_body).not_to(eq(nil))
      end
    end
  end

  describe '#query_resource' do
    context 'for adding pay recipients' do
      before(:each) do
        stub_request(:post, 'https://sandbox.kopokopo.com/api/v1/pay_recipients')
          .to_return(status: 201, body: {data: "some_data"}.to_json, headers: { location: Faker::Internet.url })
        @k2pay.add_recipient(@mobile_pay_request_body)
        stub_request(:get, @k2pay.recipients_location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
      end

      it 'should query adding pay recipients' do
        aggregate_failures do
          expect { @k2pay.query_resource(@k2pay.recipients_location_url) }.not_to(raise_error)
          expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2pay.recipients_location_url)))
        end
      end

      it 'returns a response body' do
        @k2pay.query_resource(@k2pay.recipients_location_url)
        expect(@k2pay.k2_response_body).not_to(eq(nil))
      end
    end
    before(:each) do
      stub_request(:post, 'https://sandbox.kopokopo.com/api/v1/payments')
        .to_return(status: 201, body: {data: "some_data"}.to_json, headers: { location: Faker::Internet.url })
      @k2pay.create_payment(@paybill_payment)
      stub_request(:get, @k2pay.payments_location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
    end

    it 'should query creating payment request status' do
      aggregate_failures do
        expect { @k2pay.query_resource(@k2pay.payments_location_url) }.not_to(raise_error)
        expect(WebMock).to have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(@k2pay.payments_location_url)))
      end
    end

    it 'returns a response body' do
      @k2pay.query_resource(@k2pay.payments_location_url)
      expect(@k2pay.k2_response_body).not_to(eq(nil))
    end
  end
end
