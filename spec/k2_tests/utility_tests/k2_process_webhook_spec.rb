include K2Validation

RSpec.describe K2ProcessWebhook do
  before(:context) do
    @bg_received = HashWithIndifferentAccess.new("topic": "buygoods_transaction_received",
                                                 "id": "2133dbfb-24b9-40fc-ae57-2d7559785760",
                                                 "created_at": "2020-10-22T10:43:20+03:00",
                                                 "event": {
                                                   "type": "Buygoods Transaction",
                                                   "resource": {
                                                     "id": "458712f-gr76y-24b9-40fc-ae57-2d35785760",
                                                     "amount": "100.0",
                                                     "status": "Received",
                                                     "system": "Lipa Na M-PESA",
                                                     "currency": "KES",
                                                     "reference": "OJM6Q1W84K",
                                                     "till_number": "514459",
                                                     "sender_phone_number": "+254999999999",
                                                     "origination_time": "2020-10-22T10:43:19+03:00",
                                                     "sender_last_name": "Doe",
                                                     "sender_first_name": "Jane",
                                                     "sender_middle_name": nil
                                                   }
                                                 },
                                                 "_links": {
                                                   "self": "https://sandbox.kopokopo.com/webhook_events/2133dbfb-24b9-40fc-ae57-2d7559785760",
                                                   "resource": "https://sandbox.kopokopo.com/financial_transaction/458712f-gr76y-24b9-40fc-ae57-2d35785760"
                                                 })

    @b2b = HashWithIndifferentAccess.new("topic": "b2b_transaction_received",
                                         "id": "bcfb7175-bc7f-46e8-9727-eb46e6f88ef1",
                                         "created_at": "2020-10-29T08:18:45+03:00",
                                         "event": {
                                           "type": "External Till to Till Transaction",
                                           "resource": {
                                             "id": "fbygwu7175-bc7f-46e8-9727-f88edyy",
                                             "amount": "313",
                                             "status": "Complete",
                                             "system": "Lipa Na Mpesa",
                                             "currency": "KES",
                                             "reference": "OJQ8USH5XK",
                                             "till_number": "461863",
                                             "sending_till": "890642",
                                             "origination_time": "2020-10-29T08:18:45+03:00"
                                           }
                                         },
                                         "_links": {
                                           "self": "https://sandbox.kopokopo.com/webhook_events/bcfb7175-bc7f-46e8-9727-eb46e6f88ef1",
                                           "resource": "https://sandbox.kopokopo.com/financial_transaction/fbygwu7175-bc7f-46e8-9727-f88edyy"
                                         })


    @m2m = HashWithIndifferentAccess.new("topic": "m2m_transaction_received",
                                         "id": "5fbbcfc3-5b06-485e-929c-066741f4b14d",
                                         "created_at": "2020-10-29T08:37:31+03:00",
                                         "event": {
                                           "type": "Merchant to Merchant Transaction",
                                           "resource": {
                                             "id": "893ebbcfc3-e8993-485e-929c-066741f47847",
                                             "amount": "456",
                                             "status": "Received",
                                             "currency": "KES",
                                             "origination_time": "2020-10-29T08:37:31+03:00",
                                             "sending_merchant": "Jane Flowers"
                                           }
                                         },
                                         "_links": {
                                           "self": "https://sandbox.kopokopo.com/webhook_events/5fbbcfc3-5b06-485e-929c-066741f4b14d",
                                           "resource": "https://sandbox.kopokopo.com/payment_batches/893ebbcfc3-e8993-485e-929c-066741f47847"
                                         })

    @bg_reversal = HashWithIndifferentAccess.new("topic": "buygoods_transaction_reversed",
                                                 "id": "98adf21e-5721-476a-8643-609b4a6513a2",
                                                 "created_at": "2020-10-29T08:06:49+03:00",
                                                 "event": {
                                                   "type": "Buygoods Transaction",
                                                   "resource": {
                                                     "id": "86345adf21e-5721-476a-8643-609b4a863",
                                                     "amount": "233",
                                                     "status": "Reversed",
                                                     "system": "Lipa Na Mpesa",
                                                     "currency": "KES",
                                                     "reference": "OJM6Q1W84K",
                                                     "till_number": "125476",
                                                     "origination_time": "2020-10-29T08:06:49+03:00",
                                                     "sender_last_name": "Doe",
                                                     "sender_first_name": "Jane",
                                                     "sender_middle_name": "",
                                                     "sender_phone_number": "+254999999999"
                                                   }
                                                 },
                                                 "_links": {
                                                   "self": "https://sandbox.kopokopo.com/webhook_events/98adf21e-5721-476a-8643-609b4a6513a2",
                                                   "resource": "https://sandbox.kopokopo.com/financial_transaction/86345adf21e-5721-476a-8643-609b4a863"
                                                 })

    @settlement_bank_account = HashWithIndifferentAccess.new("topic": "settlement_transfer_completed",
                                                             "id": "052b7b2a-745b-4ca1-866b-b92d4a1418c3",
                                                             "created_at": "2021-01-27T11:00:08+03:00",
                                                             "event": {
                                                               "type": "Settlement Transfer",
                                                               "resource": {
                                                                 "id": "270b7b2a-745b-6735752-b92d4a141847-5d33",
                                                                 "amount": "49452.0",
                                                                 "status": "Transferred",
                                                                 "currency": "KES",
                                                                 "destination": {
                                                                   "type": "Bank Account",
                                                                   "resource": {
                                                                     "reference": "34a273d1-fedc-4610-8ab6-a1ba4828f317",
                                                                     "account_name": "Test Account",
                                                                     "account_number": "1234",
                                                                     "bank_branch_ref": "ea2e79f7-35a1-486e-9e18-fe06589a9d7d",
                                                                     "settlement_method": "EFT"
                                                                   }
                                                                 },
                                                                 "disbursements": [
                                                                   {
                                                                     "amount": "24452.0",
                                                                     "status": "Transferred",
                                                                     "origination_time": "2021-01-27T10:57:58.623+03:00",
                                                                     "transaction_reference": nil
                                                                   },
                                                                   {
                                                                     "amount": "25000.0",
                                                                     "status": "Transferred",
                                                                     "origination_time": "2021-01-27T10:57:58.627+03:00",
                                                                     "transaction_reference": nil
                                                                   }
                                                                 ],
                                                                 "origination_time": "2021-01-27T10:57:58.444+03:00"
                                                               }
                                                             },
                                                             "_links": {
                                                               "self": "https://sandbox.kopokopo.com/webhook_events/052b7b2a-745b-4ca1-866b-b92d4a1418c3",
                                                               "resource": "https://sandbox.kopokopo.com/transfer_batch/270b7b2a-745b-6735752-b92d4a141847-5d33"
                                                             })

    @customer = HashWithIndifferentAccess.new("topic": "customer_created",
                                              "id": "f720ecf5-ff98-4ca8-a3f2-d70a65c4a02c",
                                              "created_at": "2020-10-29T08:49:02+03:00",
                                              "event": {
                                                "type": "Customer Created",
                                                "resource": {
                                                  "last_name": "Doe",
                                                  "first_name": "Jane",
                                                  "middle_name": "M",
                                                  "phone_number": "+254999999999"
                                                }
                                              },
                                              "_links": {
                                                "self": "https://sandbox.kopokopo.com/webhook_events/f720ecf5-ff98-4ca8-a3f2-d70a65c4a02c",
                                                "resource": "https://sandbox.kopokopo.com/mobile_money_user/8248a689-490e-4196-930a-db5fcbe58f6c"
                                              })
  end
  describe '#process' do
    it 'should raise an error if argument is empty' do
      expect { K2ProcessWebhook.process('', '', '') }.to raise_error ArgumentError
    end

    context 'Buy Goods Received' do
      it 'processes successfully' do
        expect { K2ProcessWebhook.process(@bg_received, 'k2_secret_key', 'bb962d85ed87a90e1a6f722dc77f60a44768c84d8c771b75d5ac5f40634d0943') }.not_to raise_error
      end

      it 'processes successfully' do
        expect(K2ProcessWebhook.process(@bg_received, 'k2_secret_key', 'bb962d85ed87a90e1a6f722dc77f60a44768c84d8c771b75d5ac5f40634d0943')).instance_of?(BuygoodsTransactionReceived)
      end

      it 'has no nil values' do
        test = K2ProcessWebhook.process(@bg_received, 'k2_secret_key', 'bb962d85ed87a90e1a6f722dc77f60a44768c84d8c771b75d5ac5f40634d0943')
        result = nil_values(test.as_json)
        expect(result).to be(nil)
      end
    end

    context 'B2b Transaction' do
      it 'processes successfully' do
        expect { K2ProcessWebhook.process(@b2b, 'k2_secret_key', '66c7221667d3733bdb9f156ac0e2a4f25df102af7213dfda4e3d249f9aaefbc5') }.not_to raise_error
      end

      it 'processes successfully' do
        expect(K2ProcessWebhook.process(@b2b, 'k2_secret_key', '66c7221667d3733bdb9f156ac0e2a4f25df102af7213dfda4e3d249f9aaefbc5')).instance_of?(B2b)
      end

      it 'has no nil values' do
        test = K2ProcessWebhook.process(@b2b, 'k2_secret_key', '66c7221667d3733bdb9f156ac0e2a4f25df102af7213dfda4e3d249f9aaefbc5')
        result = nil_values(test.as_json)
        expect(result).to be(nil)
      end
    end

    context 'Merchant to Merchant Transaction' do
      it 'processes successfully' do
        expect { K2ProcessWebhook.process(@m2m, 'k2_secret_key', '81f1baf4211f27f580887f9cbdd4ce0f6cdde9b29a8d9ae9ccf4a77f41d48f05') }.not_to raise_error
      end

      it 'processes successfully' do
        expect(K2ProcessWebhook.process(@m2m, 'k2_secret_key', '81f1baf4211f27f580887f9cbdd4ce0f6cdde9b29a8d9ae9ccf4a77f41d48f05')).instance_of?(MerchantToMerchant)
      end

      it 'has no nil values' do
        test = K2ProcessWebhook.process(@m2m, 'k2_secret_key', '81f1baf4211f27f580887f9cbdd4ce0f6cdde9b29a8d9ae9ccf4a77f41d48f05')
        result = nil_values(test.as_json)
        puts("Object: #{test.as_json.keys}")
        expect(result).to be(nil)
      end
    end

    context 'Buy Goods Reversed' do
      it 'processes successfully' do
        expect { K2ProcessWebhook.process(@bg_reversal, 'k2_secret_key', 'b0d4e69ab1d7d0efc1132947266ba0a677c270b99c78018149ff2c7ffe58fc95') }.not_to raise_error
      end

      it 'processes successfully' do
        expect(K2ProcessWebhook.process(@bg_reversal, 'k2_secret_key', 'b0d4e69ab1d7d0efc1132947266ba0a677c270b99c78018149ff2c7ffe58fc95')).instance_of?(BuygoodsTransactionReversed)
      end

      it 'has no nil values' do
        test = K2ProcessWebhook.process(@bg_reversal, 'k2_secret_key', 'b0d4e69ab1d7d0efc1132947266ba0a677c270b99c78018149ff2c7ffe58fc95')
        result = nil_values(test.as_json)
        expect(result).to be(nil)
      end
    end

    context 'Settlement Transfer Completed merchant_bank_account' do
      it 'processes successfully' do
        expect { K2ProcessWebhook.process(@settlement_bank_account, 'k2_secret_key', '794fc3795e29776d037ed159f496db21ef35c034d9515e38b59ffd2a2d6445a6') }.not_to raise_error
      end

      it 'processes successfully' do
        expect(K2ProcessWebhook.process(@settlement_bank_account, 'k2_secret_key', '794fc3795e29776d037ed159f496db21ef35c034d9515e38b59ffd2a2d6445a6')).instance_of?(SettlementWebhook)
      end

      it 'has no nil values' do
        test = K2ProcessWebhook.process(@settlement_bank_account, 'k2_secret_key', '794fc3795e29776d037ed159f496db21ef35c034d9515e38b59ffd2a2d6445a6')
        result = nil_values(test.as_json)
        expect(result).to be(nil)
      end
    end

    context 'Customer Created' do
      it 'processes successfully' do
        expect { K2ProcessWebhook.process(@customer, 'k2_secret_key', '6016cbf773c4cf8885439ea1d509e0d5acbf887d1645bbe22942f2f8fdc744d1') }.not_to raise_error
      end

      it 'processes successfully' do
        expect(K2ProcessWebhook.process(@customer, 'k2_secret_key', '6016cbf773c4cf8885439ea1d509e0d5acbf887d1645bbe22942f2f8fdc744d1')).instance_of?(CustomerCreated)
      end

      it 'has no nil values' do
        test = K2ProcessWebhook.process(@customer, 'k2_secret_key', '6016cbf773c4cf8885439ea1d509e0d5acbf887d1645bbe22942f2f8fdc744d1')
        result = nil_values(test.as_json)
        expect(result).to be(nil)
      end
    end
  end

  describe '#check_topic' do
    it 'should raise an error if event_type is not specified' do
      expect { K2ProcessWebhook.check_topic({the_body: {event: nil} } ) }.to raise_error ArgumentError
    end
  end

  describe '#return_hash' do
    it 'returns a hash object' do
      expect(K2ProcessWebhook.return_obj_hash(BuygoodsTransactionReceived.new(@bg_received))).to be_instance_of(HashWithIndifferentAccess)
    end
  end
end
