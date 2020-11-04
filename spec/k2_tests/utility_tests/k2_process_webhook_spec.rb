RSpec.describe K2ProcessWebhook do
  before(:context) do
    @bg_received = HashWithIndifferentAccess.new(topic:"buygoods_transaction_received",
                                                 id:"b0021d30-2a1c-4912-a801-671a85ae157f",
                                                 created_at:"2020-02-03T08:10:58+03:00",
                                                 event:
                                                   {
                                                     type:"Buygoods Transaction",
                                                     resource:
                                                       {
                                                         id:"ResourceID",
                                                         amount:"14141414",
                                                         status:"Complete",
                                                         system:"Lipa Na M-PESA",
                                                         currency:"KES",
                                                         reference:"Davidd_Daviidd",
                                                         till_number:"141414",
                                                         sender_phone_number:"+254999999999",
                                                         origination_time: "2020-10-22T10:43:19+03:00",
                                                         sender_last_name:"Mwangi",
                                                         sender_first_name:"David",
                                                         "sender_middle_name": nil
                                                       }
                                                   },
                                                 _links:
                                                   {
                                                     self:"https://api-sandbox.kopokopo.com/webhook_events/b0021d30-2a1c-4912-a801-671a85ae157f",
                                                     resource:"https://api-sandbox.kopokopo.com/transaction_simulation/6"
                                                   })

    @b2b = HashWithIndifferentAccess.new(topic:"b2b_transaction_received",
                                         id:"e59ac18c-9e61-433a-bd98-e96459ccc878",
                                         created_at:"2020-02-04T10:44:42+03:00",
                                         event:
                                           {
                                             type:"B2b Transaction",
                                             resource:
                                               {
                                                 id:"ResourceID",
                                                 amount:"1000",
                                                 status:"Complete",
                                                 system:"Lipa Na Mpesa",
                                                 currency:"KES",
                                                 reference:"Rf13131ju3741341",
                                                 till_number:"112233",
                                                 sending_till:"666666",
                                                 origination_time: "2020-10-29T08:18:45+03:00"
                                               }
                                           },
                                         _links:
                                           {
                                             self:"https://api-sandbox.kopokopo.com/webhook_events/b0021d30-2a1c-4912-a801-671a85ae157f",
                                             resource:"https://api-sandbox.kopokopo.com/transaction_simulation/6"
                                           },)


    @m2m = HashWithIndifferentAccess.new(topic:"m2m_transaction_received",
                                         id:"0e85db10-b902-437c-a8cf-c163ffe3a409",
                                         created_at:"2020-02-14T09:43:19+03:00",
                                         event:
                                           {
                                             type:"Merchant to Merchant Transaction",
                                             resource:
                                               {
                                                 id:"ResourceID",
                                                 amount:"20500",
                                                 currency:"KES",
                                                 status:"Received",
                                                 reference:"dd188dav1d_099sddd-eff",
                                                 origination_time:"2020-02-14T09:43:19+03:00",
                                                 sending_merchant:"Tossa Coin"
                                               }
                                           },
                                         _links:
                                           {
                                             self:"https://api-sandbox.kopokopo.com/webhook_events/0e85db10-b902-437c-a8cf-c163ffe3a409",
                                             resource:"https://api-sandbox.kopokopo.com/transaction_simulation/58"
                                           })

    @bg_reversal = HashWithIndifferentAccess.new(topic:"buygoods_transaction_reversed",
                                                 id:"4474c949-0580-4d75-918d-59e9f8e608a4",
                                                 created_at:"2020-02-14T11:02:57+03:00",
                                                 event:
                                                   {
                                                     type:"Buygoods Transaction Reversed",
                                                     resource:
                                                       {
                                                         id:"ResourceID",
                                                         amount:"8000",
                                                         currency:"KES",
                                                         status:"Complete",
                                                         system:"Safaricom",
                                                         reference:"kkt_t1p5531144_eff1ll",
                                                         till_number:"855802",
                                                         reversal_time: "2020-02-03T08:10:58+03:00",
                                                         sender_phone_number:"+254999999999",
                                                         origination_time:"2020-02-14T11:02:57+03:00",
                                                         sender_last_name:"Tips",
                                                         sender_first_name:"Kt"
                                                       }
                                                   },
                                                 _links:
                                                   {
                                                     self:"https://api-sandbox.kopokopo.com/webhook_events/4474c949-0580-4d75-918d-59e9f8e608a4",
                                                     resource:"https://api-sandbox.kopokopo.com/transaction_simulation/61"
                                                   })
    #
    @settlement_bank_account = HashWithIndifferentAccess.new(topic:"settlement_transfer_completed",
                                                             id:"f45fbc1c-8f09-4a3e-8c77-94ffe919112a",
                                                             created_at:"2020-03-02T08:55:35+03:00",
                                                             event:
                                                               {
                                                                 type:"Settlement Transfer",
                                                                 resource:
                                                                   {
                                                                     id:"ResourceID",
                                                                     amount:"value",
                                                                     currency:"KES",
                                                                     status:"Transferred",
                                                                     system:"Safaricom",
                                                                     reference:"58b86edc-97bc-47a8-a853-6cd06075db63",
                                                                     destination: {
                                                                       type: "merchant_bank_account",
                                                                       resource: {
                                                                         account_name: "account_name",
                                                                         account_number: "account_number",
                                                                         bank_branch_ref: "bank_branch_ref"
                                                                       }
                                                                     },
                                                                     origination_time:"2020-02-14T11:02:57+03:00"
                                                                   }
                                                               },
                                                             _links:
                                                               {
                                                                 self:"https://api-sandbox.kopokopo.com/webhook_events/f45fbc1c-8f09-4a3e-8c77-94ffe919112a",
                                                                 resource:"https://api-sandbox.kopokopo.com/transaction_simulation/4"
                                                               })

    @settlement_merchant_wallet = HashWithIndifferentAccess.new(topic:"settlement_transfer_completed",
                                                                id:"f45fbc1c-8f09-4a3e-8c77-94ffe919112a",
                                                                created_at:"2020-03-02T08:55:35+03:00",
                                                                event:
                                                                  {
                                                                    type:"Settlement Transfer",
                                                                    resource:
                                                                      {
                                                                        id:"ResourceID",
                                                                        origination_time:"2020-02-14T11:02:57+03:00",
                                                                        amount:"786",
                                                                        currency:"KES",
                                                                        status:"Transferred",
                                                                        destination: {
                                                                          type: "merchant_wallet",
                                                                          resource: {
                                                                            reference: "8a3755d-4417-4531-b456-9ae7e7c74c27",
                                                                            first_name: "Jane",
                                                                            last_name: "Doe",
                                                                            network: "Safaricom",
                                                                            phone_number: "+254999999999"
                                                                          }
                                                                        }
                                                                      }
                                                                  },
                                                                _links:
                                                                  {
                                                                    self:"https://api-sandbox.kopokopo.com/webhook_events/f45fbc1c-8f09-4a3e-8c77-94ffe919112a",
                                                                    resource:"https://api-sandbox.kopokopo.com/transaction_simulation/4"
                                                                  })

    @customer = HashWithIndifferentAccess.new(topic:"customer_created",
                                              id:"09a3be89-8b09-4884-b851-b2bcf1a5a111",
                                              created_at:"2020-03-02T11:06:43+03:00",
                                              event:
                                                {
                                                  type:"Customer Created",
                                                  resource:
                                                    {
                                                      phone_number: "+254999999999",
                                                      last_name: "Mwangi",
                                                      first_name: "David",
                                                      middle_name: "Kariuki"
                                                    }
                                                },
                                              _links:
                                                {
                                                  self:"https://api-sandbox.kopokopo.com/webhook_events/09a3be89-8b09-4884-b851-b2bcf1a5a111",
                                                  resource:"https://api-sandbox.kopokopo.com/transaction_simulation/8"
                                                })
  end
  describe '#process' do
    it 'should raise an error if argument is empty' do
      expect { K2ProcessWebhook.process('', '', '') }.to raise_error ArgumentError
    end

    it 'Buy Goods Received' do
      expect { K2ProcessWebhook.process(@bg_received, 'k2_secret_key', '5309d227f9efd2ca209a4fd270af13fa53921436cc89237db157d97b8b00b35c') }.not_to raise_error
    end

    it 'B2b Transaction' do
      expect { K2ProcessWebhook.process(@b2b, 'k2_secret_key', '5ac7acd456366762956a2d9a648a23d00e38a76efb3f60ad3d5748e88efc6ae2') }.not_to raise_error
    end

    it 'Merchant to Merchant Transaction' do
      expect { K2ProcessWebhook.process(@m2m, 'k2_secret_key', '47457808bee8ee9639a87cb0ac394dfb34e4f96bf205df6e7757eadcaf0e1f8b') }.not_to raise_error
    end

    it 'Buy Goods Reversed' do
      expect { K2ProcessWebhook.process(@bg_reversal, 'k2_secret_key', '2968acb00a91f807751c75e264396b194b6b1c90f0751fd1d24195eafb5e904c') }.not_to raise_error
    end

    it 'Settlement Transfer Completed merchant_bank_account' do
      expect { K2ProcessWebhook.process(@settlement_bank_account, 'k2_secret_key', '4a6c0c989c072bd16b199378147dea96ecec77c0b5f787bfb6943e30a6ed2df5') }.not_to raise_error
    end

    it 'Settlement Transfer Completed merchant_wallet' do
      expect { K2ProcessWebhook.process(@settlement_merchant_wallet, 'k2_secret_key', 'e7e9b3d8cfda6027832616c4181ef1ac55a1a6bf1d3744d5618c67e4ee234e4b') }.not_to raise_error
    end

    it 'Customer Created' do
      expect { K2ProcessWebhook.process(@customer, 'k2_secret_key', '923d34cfd06a3d1af68dce4ef46fe66d44bb6e27b097e2e73db950dd2819f78e') }.not_to raise_error
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
