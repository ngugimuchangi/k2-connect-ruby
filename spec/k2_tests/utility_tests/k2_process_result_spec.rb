RSpec.describe K2ProcessResult do
  before(:context) do
    @stk = HashWithIndifferentAccess.new("data": {
      "id": "a652f86f-f2aa-4d70-baa2-ccfe4b78f4fc",
      "type": "incoming_payment",
      "attributes": {
        "initiation_time": "2020-10-19T09:24:48.622+03:00",
        "status": "Success",
        "event": {
          "type": "Incoming Payment Request",
          "resource": {
            "id": "52f86f-f2aa-4d70-baa2-ccfe4b78f4fc",
            "reference": "OJJ1MPU40Z",
            "origination_time": "2020-10-19T09:24:54+03:00",
            "sender_phone_number": "+254999999999",
            "amount": "100.0",
            "currency": "KES",
            "till_number": "K514459",
            "system": "Lipa Na M-PESA",
            "status": "Received",
            "sender_first_name": "Joe",
            "sender_middle_name": nil,
            "sender_last_name": "Buyer"
          },
          "errors": nil
        },
        "metadata": {
          "customer_id": "123456789",
          "reference": "123456",
          "notes": "Payment for invoice 12345"
        },
        "_links": {
          "callback_url": "https://webhook.site/675d4ef4-0629-481f-83cd-d101f55e4bc8",
          "self": "http://sandbox.kopokopo.com/api/v1/incoming_payments/a652f86f-f2aa-4d70-baa2-ccfe4b78f4fc"
        }
      }
    })

    @pay = HashWithIndifferentAccess.new("data": {
      "id": "c6fda139-2480-4a93-95ed-f72c66b92364",
      "type": "payment",
      "attributes": {
        "status": "Processed",
        "created_at": "2021-01-28T10:00:17.827+03:00",
        "amount": {
          "currency": "KES",
          "value": 780
        },
        "transfer_batches": [
          {
            "status": "Transferred",
            "disbursements": [
              {
                "amount": "780.0",
                "status": "Transferred",
                "destination_type": "Mobile Wallet",
                "origination_time": "2020-11-13T08:32:03.000+03:00",
                "destination_reference": "0fcb2f42-9372-4a6c-8c2f-3fd977c548e8",
                "transaction_reference": "LBA10034460"
              }
            ]
          }
        ],
        "metadata": {
          "notes": "Salary payment for May 2018",
          "customerId": "8675309",
          "something_else": "Something else"
        },
        "_links": {
          "callback_url": "https://webhook.site/3856ff77-93eb-4130-80cd-e62dc0db5c1a",
          "self": "https://sandbox.kopokopo.com/api/v1/payments/c6fda139-2480-4a93-95ed-f72c66b92364"
        }
      }
    })

    @mobile_wallet_transfer = HashWithIndifferentAccess.new("data": {
      "id": "01aece24-e596-4f5c-9ace-9eb1a0939dda",
      "type": "settlement_transfer",
      "attributes": {
        "status": "Processed",
        "created_at": "2021-01-27T10:57:09.838+03:00",
        "amount": {
          "currency": "KES",
          "value": nil
        },
        "transfer_batches": [
          {
            "status": "Transferred",
            "disbursements": [
              {
                "amount": "19900.0",
                "status": "Transferred",
                "destination_type": "Mobile Wallet",
                "origination_time": "2021-01-06T12:42:36.000+03:00",
                "destination_reference": "17067bf7-648e-424c-af0f-8c541a1b4ec3",
                "transaction_reference": "LDLJANAPH26"
              }
            ]
          },
          {
            "status": "Transferred",
            "disbursements": [
              {
                "amount": "24452.0",
                "status": "Transferred",
                "destination_type": "Bank Account",
                "origination_time": "2021-01-27T10:57:58.623+03:00",
                "destination_reference": "34a273d1-fedc-4610-8ab6-a1ba4828f317",
                "transaction_reference": nil
              },
              {
                "amount": "25000.0",
                "status": "Transferred",
                "destination_type": "Bank Account",
                "origination_time": "2021-01-27T10:57:58.627+03:00",
                "destination_reference": "34a273d1-fedc-4610-8ab6-a1ba4828f317",
                "transaction_reference": nil
              }
            ]
          }
        ],
        "_links": {
          "callback_url": "https://webhook.site/3856ff77-93eb-4130-80cd-e62dc0db5c1a",
          "self": "https://sandbox.kopokopo.com/api/v1/settlement_transfers/01aece24-e596-4f5c-9ace-9eb1a0939dda"
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
        expect { K2ProcessResult.process(@stk, 'api_secret_key', 'd627df47431db2814673efdcb3e76a6c96a4ed12b18f36716b4ca3f9f983b480') }.not_to raise_error
      end

      it 'returns an STK Object' do
        expect(K2ProcessResult.process(@stk, 'api_secret_key', 'd627df47431db2814673efdcb3e76a6c96a4ed12b18f36716b4ca3f9f983b480')).instance_of?(K2Stk)
      end
    end

    context 'Process Pay Result' do
      it 'processes successfully' do
        expect { K2ProcessResult.process(@pay, 'api_secret_key', '466452be2841cd52b8f5ee309e12b975f18047fd633704ed6b0c33d7fa506512') }.not_to raise_error
      end

      it 'returns an PAY Object' do
        expect(K2ProcessResult.process(@pay, 'api_secret_key', '466452be2841cd52b8f5ee309e12b975f18047fd633704ed6b0c33d7fa506512')).instance_of?(K2Pay)
      end
    end

    context 'Process Transfer Result' do
      it 'processes successfully' do
        expect { K2ProcessResult.process(@mobile_wallet_transfer, 'api_secret_key', '54b24a51d61d16e143759fb96c7e043887fa5f4923e377e144defc914b438393') }.not_to raise_error
      end

      it 'returns an Transfer Object' do
        expect(K2ProcessResult.process(@mobile_wallet_transfer, 'api_secret_key', '54b24a51d61d16e143759fb96c7e043887fa5f4923e377e144defc914b438393')).instance_of?(K2Transfer)
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
