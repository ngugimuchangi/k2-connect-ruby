RSpec.describe K2ProcessResult do
  before(:context) do
    @bg_received = HashWithIndifferentAccess.new( id: 'cac95329-9fa5-42f1-a4fc-c08af7b868fb', resourceId: 'cdb5f11f-62df-e611-80ee-0aa34a9b2388', topic: 'transaction_received',
                                                  created_at: '2017-01-20T22:45:12.790Z',
                                                  event: { type: 'Buygoods Transaction',
                                                           resource: { reference: 'KKPPLLMMNN', origination_time: '2017-01-20T22:45:12.790Z', sender_msisdn: '+2549703119050',
                                                                       amount: 3_000, currency: 'KES', till_number: 111_222, system: 'Lipa Na M-PESA', status: 'Received',
                                                                       sender_first_name: 'John', sender_middle_name: 'O', sender_last_name: 'Doe' } },
                                                  _links: { self: 'https://api-sandbox.kopokopo.com/events/cac95329-9fa5-42f1-a4fc-c08af7b868fb',
                                                            resource: 'https://api-sandbox.kopokopo.com/buygoods_transaction/cdb5f11f-62df-e611-80ee-0aa34a9b2388' })

    @b2b = HashWithIndifferentAccess.new( id: 'cac95329-9fa5-42f1-a4fc-c08af7b868fb', resourceId: 'cdb5f11f-62df-e611-80ee-0aa34a9b2388', topic: 'transaction_received',
                                          created_at: '2017-01-20T22:45:12.790Z',
                                          event: { type: 'B2b Transaction',
                                                   resource: { reference: 'KKPPLLMMNN', origination_time: '2017-01-20T22:45:12.790Z', sending_till: 119_050,
                                                               amount: 3_000, currency: 'KES', till_number: 111_222, system: 'Lipa Na M-PESA', status: 'Received' } },
                                          _links: { self: 'https://api-sandbox.kopokopo.com/events/cac95329-9fa5-42f1-a4fc-c08af7b868fb',
                                                    resource: 'https://api-sandbox.kopokopo.com/buygoods_transaction/cdb5f11f-62df-e611-80ee-0aa34a9b2388' })

    @m2m = HashWithIndifferentAccess.new( id: 'cac95329-9fa5-42f1-a4fc-c08af7b868fb', resourceId: 'cdb5f11f-62df-e611-80ee-0aa34a9b2388', topic: 'transaction_received',
                                          created_at: '2017-01-20T22:45:12.790Z',
                                          event: { type: 'Merchant to Merchant Transaction',
                                                   resource: { reference: 'KKPPLLMMNN', origination_time: '2017-01-20T22:45:12.790Z', sending_merchant: 'Kings Landing Enterprises',
                                                               amount: 3_000, currency: 'KES', till_number: 111_222, system: 'Lipa Na M-PESA', status: 'Received' } },
                                          _links: { self: 'https://api-sandbox.kopokopo.com/events/cac95329-9fa5-42f1-a4fc-c08af7b868fb',
                                                    resource: 'https://api-sandbox.kopokopo.com/buygoods_transaction/cdb5f11f-62df-e611-80ee-0aa34a9b2388' })

    @bg_reversal = HashWithIndifferentAccess.new( id: 'cac95329-9fa5-42f1-a4fc-c08af7b868fb', resourceId: 'cdb5f11f-62df-e611-80ee-0aa34a9b2388', topic: 'buygoods_transaction_reversed',
                                                  created_at: '2017-01-20T22:45:12.790Z',
                                                  event: { type: 'Buygoods Transaction Reversed',
                                                           resource: { reference: 'KKPPLLMMNN', origination_time: '2018-01-20T22:45:12.790Z', reversal_time: '2018-01-21T22:45:12.790Z',
                                                                       sender_msisdn: '+2549703119050', amount: 3_000, currency: 'KES', till_number: 111_222, system: 'Lipa Na M-PESA',
                                                                       status: 'Reversed', sender_first_name: 'John', sender_middle_name: 'O', sender_last_name: 'Doe' } },
                                                  _links: { self: 'https://api-sandbox.kopokopo.com/events/cac95329-9fa5-42f1-a4fc-c08af7b868fb',
                                                            resource: 'https://api-sandbox.kopokopo.com/buygoods_transaction/cdb5f11f-62df-e611-80ee-0aa34a9b2388' })

    @settlement = HashWithIndifferentAccess.new( id: 'cac95329-9fa5-42f1-a4fc-c08af7b868fb', resourceId: 'cdb5f11f-62df-e611-80ee-0aa34a9b2388', topic: 'settlement_transfer_completed',
                                                 created_at: '2017-01-20T22:45:12.790Z',
                                                 event: { type: 'Settlement',
                                                          resource: { reference: 'KKPPLLMMNN', origination_time: '2017-01-20T22:45:12.790Z', transfer_time: '2018-01-21T22:45:12.790Z',
                                                                      transfer_type: 'Mobile Transfer', amount: 3_000, currency: 'KES', status: 'Transferred',
                                                                      destination: { type: 'mobile', msisdn: '+254909999999', mm_system: 'Safaricom' } } },
                                                 _links: { self: 'https://api-sandbox.kopokopo.com/events/cac95329-9fa5-42f1-a4fc-c08af7b868fb',
                                                           resource: 'https://api-sandbox.kopokopo.com/buygoods_transaction/cdb5f11f-62df-e611-80ee-0aa34a9b2388' })

    @customer = HashWithIndifferentAccess.new( id: 'cac95329-9fa5-42f1-a4fc-c08af7b868fb', resourceId: 'cdb5f11f-62df-e611-80ee-0aa34a9b2388', topic: 'customer_created',
                                               created_at: '2017-01-20T22:45:12.790Z',
                                               event: { type: 'Customer Created',
                                                        resource: { msisdn: '+2549703119050', first_name: 'John', middle_name: 'O', last_name: 'Doe' } },
                                               _links: { self: 'https://api-sandbox.kopokopo.com/events/cac95329-9fa5-42f1-a4fc-c08af7b868fb',
                                                         resource: 'https://api-sandbox.kopokopo.com/buygoods_transaction/cdb5f11f-62df-e611-80ee-0aa34a9b2388' })

    @stk = HashWithIndifferentAccess.new( id: 'cac95329-9fa5-42f1-a4fc-c08af7b868fb', resourceId: 'cdb5f11f-62df-e611-80ee-0aa34a9b2388', topic: 'payment_request',
                                          created_at: '2017-01-20T22:45:12.790Z', status: 'Success',
                                          event: { type: 'Payment Request',
                                                   resource: { reference: 'KKPPLLMMNN', origination_time: '2017-01-20T22:45:12.790Z', sender_msisdn: '+2549703119050',
                                                               amount: 20_000, currency: 'KES', till_number: 111_222, system: 'Lipa Na M-PESA', status: 'Received',
                                                               sender_first_name: 'John', sender_middle_name: 'O', sender_last_name: 'Doe' },
                                                   errors: [] },
                                          metadata: { customer_id: 123_456_789, reference: 123_456, notes: 'Payment for invoice 123456' },
                                          _links: { self: 'https://api-sandbox.kopokopo.com/events/cac95329-9fa5-42f1-a4fc-c08af7b868fb',
                                                    payment_request: 'https://api-sandbox.kopokopo.com/payment_requests/cac95329-9fa5-42f1-a4fc-c08af7b868fb',
                                                    resource: 'https://api-sandbox.kopokopo.com/buygoods_transaction/cdb5f11f-62df-e611-80ee-0aa34a9b2388' })

    @failed_stk = HashWithIndifferentAccess.new( id: 'cac95329-9fa5-42f1-a4fc-c08af7b868fb', resourceId: 'null', topic: 'payment_request',
                                                 created_at: '2017-01-20T22:45:12.790Z', status: 'Failed',
                                                 event: { type: 'Payment Request',
                                                          resource: 'null', errors: [ { code: 501, description: 'Insufficient funds' } ] },
                                                 metadata: { customer_id: 123_456_789, reference: 123_456, notes: 'Payment for invoice 123456' },
                                                 _links: { self: 'https://api-sandbox.kopokopo.com/events/cac95329-9fa5-42f1-a4fc-c08af7b868fb',
                                                           resource: 'https://api-sandbox.kopokopo.com/buygoods_transaction/cdb5f11f-62df-e611-80ee-0aa34a9b2388' })

    @pay = HashWithIndifferentAccess.new( id: 'cac95329-9fa5-42f1-a4fc-c08af7b868fb', topic: 'pay_request', status: 'Sent', reference: 'KKPPLLMMNN',
                                          origination_time: '2017-01-20T22:45:12.790Z',  destination: 'c7f300c0-f1ef-4151-9bbe-005005aa3747',
                                          amount: { currency: 'KES', value: 20_000 },
                                          metadata: { customerId: 8_675_309, notes: 'Salary payment for May 2018' },
                                          _links: { self: 'https://api-sandbox.kopokopo.com/events/cac95329-9fa5-42f1-a4fc-c08af7b868fb' })
  end
  context '#process' do
    it 'should raise an error if argument is empty' do
      expect { K2ProcessResult.process('') }.to raise_error ArgumentError
    end

    it 'Buy Goods Received' do
      expect { K2ProcessResult.process(@bg_received) }.not_to raise_error
    end

    it 'B2b Transaction' do
      expect { K2ProcessResult.process(@b2b) }.not_to raise_error
    end

    it 'Merchant to Merchant Transaction' do
      expect { K2ProcessResult.process(@m2m) }.not_to raise_error
    end

    it 'Buy Goods Reversed' do
      expect { K2ProcessResult.process(@bg_reversal) }.not_to raise_error
    end

    it 'Settlement Transfer Completed' do
      expect { K2ProcessResult.process(@settlement) }.not_to raise_error
    end

    it 'Customer Created' do
      expect { K2ProcessResult.process(@customer) }.not_to raise_error
    end

    it 'Process Stk Result' do
      expect { K2ProcessResult.process(@stk) }.not_to raise_error
    end

    it 'Failed Stk Result' do
      expect { K2ProcessResult.process(@failed_stk) }.not_to raise_error
    end

    it 'Process PAY Result' do
      expect { K2ProcessResult.process(@pay) }.not_to raise_error
    end
  end

  context '#check_topic' do
    it 'should raise an error if event_type is not specified' do
      expect { K2ProcessResult.check_topic( {the_body: { event: nil} } ) }.to raise_error ArgumentError
    end
  end

  context '#return_hash' do
    it 'returns a hash object' do
      expect { K2ProcessResult.return_obj_hash(K2ProcessPay.new.components(@pay)) }.not_to raise_error
    end
  end
end
