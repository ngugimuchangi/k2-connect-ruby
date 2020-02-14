RSpec.describe K2ProcessResult do
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
                                                                 system:"M-PESA",
                                                                 currency:"KES",
                                                                 reference:"Davidd_Daviidd",
                                                                 till_number:"141414",
                                                                 sender_msisdn:"jbvkjdbfhjf",
                                                                 origination_time:"nil",
                                                                 sender_last_name:"Mwangi",
                                                                 sender_first_name:"David"
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
                                                         system:"76812468712",
                                                         currency:"KES",
                                                         reference:"Rf13131ju3741341",
                                                         till_number:"112233",
                                                         sending_till:"666666",
                                                         origination_time:"nil",
                                                         sender_last_name:"Mwangi",
                                                         sender_first_name:"David"
                                                     }
                                             },
                                         _links:
                                             {
                                                 self:"https://api-sandbox.kopokopo.com/webhook_events/b0021d30-2a1c-4912-a801-671a85ae157f",
                                                 resource:"https://api-sandbox.kopokopo.com/transaction_simulation/6"
                                             },)

    #
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
                                                         status:"Complete",
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
                                                                 sender_msisdn:"254711111111",
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
    # @settlement = HashWithIndifferentAccess.new( id: 'cac95329-9fa5-42f1-a4fc-c08af7b868fb', resourceId: 'cdb5f11f-62df-e611-80ee-0aa34a9b2388', topic: 'settlement_transfer_completed',
    #                                              created_at: '2017-01-20T22:45:12.790Z',
    #                                              event: { type: 'Settlement',
    #                                                       resource: { reference: 'KKPPLLMMNN', origination_time: '2017-01-20T22:45:12.790Z', transfer_time: '2018-01-21T22:45:12.790Z',
    #                                                                   transfer_type: 'Mobile Transfer', amount: 3_000, currency: 'KES', status: 'Transferred',
    #                                                                   destination: { type: 'mobile', msisdn: '+254909999999', mm_system: 'Safaricom' } } },
    #                                              _links: { self: 'https://api-sandbox.kopokopo.com/events/cac95329-9fa5-42f1-a4fc-c08af7b868fb',
    #                                                        resource: 'https://api-sandbox.kopokopo.com/buygoods_transaction/cdb5f11f-62df-e611-80ee-0aa34a9b2388' })
    #
    # @customer = HashWithIndifferentAccess.new( id: 'cac95329-9fa5-42f1-a4fc-c08af7b868fb', resourceId: 'cdb5f11f-62df-e611-80ee-0aa34a9b2388', topic: 'customer_created',
    #                                            created_at: '2017-01-20T22:45:12.790Z',
    #                                            event: { type: 'Customer Created',
    #                                                     resource: { msisdn: '+2549703119050', first_name: 'John', middle_name: 'O', last_name: 'Doe' } },
    #                                            _links: { self: 'https://api-sandbox.kopokopo.com/events/cac95329-9fa5-42f1-a4fc-c08af7b868fb',
    #                                                      resource: 'https://api-sandbox.kopokopo.com/buygoods_transaction/cdb5f11f-62df-e611-80ee-0aa34a9b2388' })

    @stk = HashWithIndifferentAccess.new(data: {
        id:"678ea9f2-0958-4c57-beed-1417394fce45",
        type:"incoming_payment",
        attributes:
            {
                initiation_time:"2020-02-03T07:50:11.417+03:00",
                status:"Received",
                event:
                    {
                        type:"Buygoods Transaction",
                        resource:
                            {
                                transaction_reference:"1580705411",
                                origination_time:"2020-02-03T07:50:11.732+03:00",
                                sender_msisdn:"+254716230902",
                                amount:"20000.0",
                                currency:"KES",
                                till_identifier:"444555",
                                system:"Lipa Na MPESA",
                                status:"Received",
                                sender_first_name:"David",
                                sender_last_name:"Mwangi"

                            },
                        errors:[]
                    },
                meta_data:
                    {
                        notes:"Payment for invoice 12345",
                        reference:"123456",
                        customer_id:"123456789"
                    },
                _links:
                    {
                        callback_url:"https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3",
                        self:"http://localhost:3000/api/v1/payments/678ea9f2-0958-4c57-beed-1417394fce45"
                    }
            }
    })

    # @failed_stk = HashWithIndifferentAccess.new( id: 'cac95329-9fa5-42f1-a4fc-c08af7b868fb', resourceId: 'null', topic: 'payment_request',
    #                                              created_at: '2017-01-20T22:45:12.790Z', status: 'Failed',
    #                                              event: { type: 'Payment Request',
    #                                                       resource: 'null', errors: [ { code: 501, description: 'Insufficient funds' } ] },
    #                                              metadata: { customer_id: 123_456_789, reference: 123_456, notes: 'Payment for invoice 123456' },
    #                                              _links: { self: 'https://api-sandbox.kopokopo.com/events/cac95329-9fa5-42f1-a4fc-c08af7b868fb',
    #                                                        resource: 'https://api-sandbox.kopokopo.com/buygoods_transaction/cdb5f11f-62df-e611-80ee-0aa34a9b2388' })

    @pay = HashWithIndifferentAccess.new(data: {
        id:"59f350e0-7695-422f-9f52-c25b9cb05180",
        type:"payment",
        attributes:
            {
                transaction_reference:"1580706111",
                destination:"c7f300c0-f1ef-4151-9bbe-005005aa3747",
                status:"Sent",
                origination_time:"2020-02-03T08:01:51.481+03:00",
                initiation_time:"2020-02-03T08:01:51.433+03:00",
                amount:
                    {
                        currency:"KES",
                        value:"20000.0"

                    },
                meta_data:
                    {
                        notes:"Salary payment for May 2018",
                        customerId:"8675309",
                        something_else:"Something else"

                    },
                _links:
                    {
                        callback_url:"https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3",
                        self:"http://localhost:3000/api/v1/payments/59f350e0-7695-422f-9f52-c25b9cb05180"
                    }
            }
    })

    @transfer = HashWithIndifferentAccess.new(data: {
        id:"7db9f7f7-4ef8-4df9-a6a9-d62db042fcc1",
        type:"transfer",
        attributes:
            {
                transaction_reference:"1581315324",
                destination:"c7f300c0-f1ef-4151-9bbe-005005aa3747",
                status:"Sent",
                origination_time:"2020-02-03T08:01:51.481+03:00",
                initiation_time:"2020-02-03T08:01:51.433+03:00",
                amount:
                    {
                        currency:"KES",
                        value:"20000.0"

                    },
                meta_data:
                    {
                        notes:"Salary payment for May 2018",
                        customerId:"8675309",
                        something_else:"Something else"

                    },
                _links:
                    {
                        callback_url:"https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3",
                        self:"http://localhost:3000/api/v1/payments/59f350e0-7695-422f-9f52-c25b9cb05180"
                    }
            }
    })
  end
  context '#process' do
    it 'should raise an error if argument is empty' do
      expect { K2ProcessWebhook.process('') }.to raise_error ArgumentError
    end

    it 'Buy Goods Received' do
      expect { K2ProcessWebhook.process(@bg_received) }.not_to raise_error
    end

    it 'B2b Transaction' do
      expect { K2ProcessWebhook.process(@b2b) }.not_to raise_error
    end

    it 'Merchant to Merchant Transaction' do
      expect { K2ProcessWebhook.process(@m2m) }.not_to raise_error
    end

    it 'Buy Goods Reversed' do
      expect { K2ProcessWebhook.process(@bg_reversal) }.not_to raise_error
    end
    #
    # it 'Settlement Transfer Completed' do
    #   expect { K2ProcessResult.process(@settlement) }.not_to raise_error
    # end
    #
    # it 'Customer Created' do
    #   expect { K2ProcessResult.process(@customer) }.not_to raise_error
    # end

    it 'Process Stk Result' do
      expect { K2ProcessResult.process(@stk) }.not_to raise_error
      expect(K2ProcessResult.process(@stk)).not_to be nil
    end

    # it 'Failed Stk Result' do
    #   expect { K2ProcessResult.process(@failed_stk) }.not_to raise_error
    # end

    it 'Process PAY Result' do
      expect { K2ProcessResult.process(@pay) }.not_to raise_error
      expect(K2ProcessResult.process(@pay)).not_to be nil
    end

    it 'Process Transfer Result' do
      expect { K2ProcessResult.process(@transfer) }.not_to raise_error
      expect(K2ProcessResult.process(@transfer)).not_to be nil
    end
  end

  context '#check_topic' do
    it 'should raise an error if event_type is not specified' do
      expect { K2ProcessResult.check_type({the_body: {event: nil} } ) }.to raise_error ArgumentError
    end
  end

  context '#return_hash' do
    it 'returns a hash object' do
      expect(K2ProcessResult.return_obj_hash(OutgoingPayment.new(@pay))).to be_instance_of(HashWithIndifferentAccess)
    end
  end
end
