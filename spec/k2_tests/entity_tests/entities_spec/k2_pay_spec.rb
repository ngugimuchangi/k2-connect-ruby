include K2Validation
RSpec.describe K2Pay do
  before(:all) do
    @access_token = K2AccessToken.new('qDeh9J2HibyXJYQsT8RYbh_HCdAy-438jBINt4rfyhw', 'NvC6pSJFqWOaC-VuaEIFooyoHdlBh54GluRb2RGhm1M').request_token
    @k2pay = K2Pay.new(@access_token)

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
    context "Adding a Mobile PAY Recipient" do
      context "Correct recipient details" do
        it 'should send an add mobile wallet pay recipient request' do
          SpecConfig.custom_stub_request('post', K2Config.path_url('pay_recipient'), @mobile_pay_request_body, 201)
          @k2pay.add_recipient(@mobile_pay_request_body)
          expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('pay_recipient')))
        end

        it 'returns a location_url' do
          @k2pay.add_recipient(@mobile_pay_request_body)
          expect(@k2pay.recipients_location_url).not_to eq(nil)
        end
      end

      context "Wrong recipient details" do
        it 'should not send an add mobile wallet pay recipient request' do
          expect { @k2pay.add_recipient(@incorrect_network) }.to raise_error ArgumentError
          expect(WebMock).not_to have_requested(:post, URI.parse(K2Config.path_url('pay_recipient')))
        end
      end
    end

    context "Adding a Bank PAY Recipient" do
      context "Correct recipient details" do
        context "EFT settlement_method" do
          it 'should send an add bank account pay recipient request' do
            SpecConfig.custom_stub_request('post', K2Config.path_url('pay_recipient'), @bank_pay_request_body_eft, 201)
            @k2pay.add_recipient(@bank_pay_request_body_eft)
            expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('pay_recipient')))
          end

          it 'returns a location_url' do
            @k2pay.add_recipient(@bank_pay_request_body_eft)
            expect(@k2pay.recipients_location_url).not_to eq(nil)
          end
        end

        context "RTS settlement_method" do
          it 'should send an add bank account pay recipient request' do
            SpecConfig.custom_stub_request('post', K2Config.path_url('pay_recipient'), @bank_pay_request_body_rts, 201)
            @k2pay.add_recipient(@bank_pay_request_body_rts)
            expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('pay_recipient')))
          end

          it 'returns a location_url' do
            @k2pay.add_recipient(@bank_pay_request_body_rts)
            expect(@k2pay.recipients_location_url).not_to eq(nil)
          end
        end
      end

      context "Wrong recipient details" do
        context "Wrong settlment method" do
          it 'should not send an add bank account pay recipient request' do
            expect { @k2pay.add_recipient(@wrong_bank_pay_request_body) }.to raise_error ArgumentError
            expect(WebMock).not_to have_requested(:post, URI.parse(K2Config.path_url('pay_recipient')))
          end
        end
      end
    end

    context "Adding a Till PAY Recipient" do
      context "Correct recipient details" do
        it 'should send an add till pay recipient request' do
          SpecConfig.custom_stub_request('post', K2Config.path_url('pay_recipient'), @till_pay_request_body, 201)
          @k2pay.add_recipient(@till_pay_request_body)
          expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('pay_recipient')))
        end

        it 'returns a location_url' do
          @k2pay.add_recipient(@till_pay_request_body)
          expect(@k2pay.recipients_location_url).not_to eq(nil)
        end
      end
    end

    context "Adding a Paybill PAY Recipient" do
      context "Correct recipient details" do
        it 'should send an add paybill pay recipient request' do
          SpecConfig.custom_stub_request('post', K2Config.path_url('pay_recipient'), @paybill_pay_request_body, 201)
          @k2pay.add_recipient(@paybill_pay_request_body)
          expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('pay_recipient')))
        end

        it 'returns a location_url' do
          @k2pay.add_recipient(@paybill_pay_request_body)
          expect(@k2pay.recipients_location_url).not_to eq(nil)
        end
      end
    end
  end

  describe ' #create_payment' do
    context 'mobile_wallet destination_type' do
      it 'should create outgoing payment request' do
        SpecConfig.custom_stub_request('post', K2Config.path_url('payments'), @mobile_wallet_payment, 201)
        @k2pay.create_payment(@mobile_wallet_payment)
        expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('payments')))
      end

      it 'should create a payment location_url' do
        @k2pay.create_payment(@mobile_wallet_payment)
        expect(@k2pay.payments_location_url).not_to eq(nil)
      end
    end

    context 'bank_account destination_type' do
      it 'should create outgoing payment request' do
        SpecConfig.custom_stub_request('post', K2Config.path_url('payments'), @bank_account_payment, 201)
        @k2pay.create_payment(@bank_account_payment)
        expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('payments')))
      end

      it 'should create a payment location_url' do
        @k2pay.create_payment(@bank_account_payment)
        expect(@k2pay.payments_location_url).not_to eq(nil)
      end
    end

    context 'till destination_type' do
      it 'should create outgoing payment request' do
        SpecConfig.custom_stub_request('post', K2Config.path_url('payments'), @till_payment, 201)
        @k2pay.create_payment(@till_payment)
        expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('payments')))
      end

      it 'should create a payment location_url' do
        @k2pay.create_payment(@till_payment)
        expect(@k2pay.payments_location_url).not_to eq(nil)
      end
    end

    context 'paybill destination_type' do
      it 'should create outgoing payment request' do
        SpecConfig.custom_stub_request('post', K2Config.path_url('payments'), @paybill_payment, 201)
        @k2pay.create_payment(@paybill_payment)
        expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('payments')))
      end

      it 'should create a payment location_url' do
        @k2pay.create_payment(@paybill_payment)
        expect(@k2pay.payments_location_url).not_to eq(nil)
      end
    end
  end

  describe '#query_status' do
    context 'for adding pay recipients' do
      it 'should query adding pay recipients' do
        SpecConfig.custom_stub_request('get', @k2pay.recipients_location_url, '', 200)
        expect { @k2pay.query_status('recipients') }.not_to raise_error
        expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2pay.recipients_location_url)))
      end

      it 'returns a response body' do
        @k2pay.query_status('recipients')
        expect(@k2pay.k2_response_body).not_to eq(nil)
      end
    end

    context 'for creating payments' do
      it 'should query creating payment request status' do
        SpecConfig.custom_stub_request('get', @k2pay.payments_location_url, @create_request_body, 200)
        expect { @k2pay.query_status('payments') }.not_to raise_error
        expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2pay.payments_location_url)))
      end

      it 'returns a response body' do
        @k2pay.query_status('payments')
        expect(@k2pay.k2_response_body).not_to eq(nil)
      end
    end
  end

  describe '#query_resource' do
    context 'for adding pay recipients' do
      it 'should query adding pay recipients' do
        SpecConfig.custom_stub_request('get', @k2pay.recipients_location_url, '', 200)
        expect { @k2pay.query_resource(@k2pay.recipients_location_url) }.not_to raise_error
        expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2pay.recipients_location_url)))
      end

      it 'returns a response body' do
        @k2pay.query_resource(@k2pay.recipients_location_url)
        expect(@k2pay.k2_response_body).not_to eq(nil)
      end
    end

    it 'should query creating payment request status' do
      SpecConfig.custom_stub_request('get', @k2pay.payments_location_url, @create_request_body, 200)
      expect { @k2pay.query_resource(@k2pay.payments_location_url) }.not_to raise_error
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2pay.payments_location_url)))
    end

    it 'returns a response body' do
      @k2pay.query_resource(@k2pay.payments_location_url)
      expect(@k2pay.k2_response_body).not_to eq(nil)
    end
  end
end
