RSpec.describe K2ProcessResult do
  before(:context) do
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
        type:"settlement_transfer",
        attributes:
            {
                destination_type: "merchant_wallet",
                destination_reference: "cbe4bcff-c453-49e1-a504-85b6845e4018",
                status:"Transferred",
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

  describe '#process' do
    it 'should raise an error if argument is empty' do
      expect { K2ProcessResult.process('', '', '') }.to raise_error ArgumentError, 'Empty/Nil Request Body Argument!'
    end

    context 'Process Stk Result' do
      it 'processes successfully' do
        expect { K2ProcessResult.process(@stk, 'api_secret_key', '74641480421af7e1caa4480934dc05268c40bfa4ad2a917253f67d2e7744d1f6') }.not_to raise_error
      end

      it 'returns an STK Object' do
        expect(K2ProcessResult.process(@stk, 'api_secret_key', '74641480421af7e1caa4480934dc05268c40bfa4ad2a917253f67d2e7744d1f6')).instance_of?(K2Stk)
      end
    end

    context 'Process Pay Result' do
      it 'processes successfully' do
        expect { K2ProcessResult.process(@pay, 'api_secret_key', 'b0940b2cb64f410449a99528ec25f2510845cea3a56db55beddd650373a276d9') }.not_to raise_error
      end

      it 'returns an PAY Object' do
        expect(K2ProcessResult.process(@pay, 'api_secret_key', 'b0940b2cb64f410449a99528ec25f2510845cea3a56db55beddd650373a276d9')).instance_of?(K2Pay)
      end
    end

    context 'Process Transfer Result' do
      it 'processes successfully' do
        expect { K2ProcessResult.process(@transfer, 'api_secret_key', '39bfcdeb45ca3f13d0d8350a22e08fbab172139d938be8ef3e0c7fc0925a2006') }.not_to raise_error
      end

      it 'returns an Transfer Object' do
        expect(K2ProcessResult.process(@transfer, 'api_secret_key', '39bfcdeb45ca3f13d0d8350a22e08fbab172139d938be8ef3e0c7fc0925a2006')).instance_of?(K2Transfer)
      end
    end
  end

  describe '#check_type' do
    it 'should raise an error if event_type is not specified' do
      expect { K2ProcessResult.check_type({the_body: {event: nil} } ) }.to raise_error ArgumentError
    end
  end

  describe '#return_hash' do
    it 'returns a hash object' do
      expect(K2ProcessResult.return_obj_hash(OutgoingPayment.new(@pay))).to be_instance_of(HashWithIndifferentAccess)
    end
  end
end
