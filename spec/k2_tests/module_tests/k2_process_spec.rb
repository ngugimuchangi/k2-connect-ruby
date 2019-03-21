RSpec.describe K2ProcessResult do
  before(:context) do
    @the_body = HashWithIndifferentAccess.new(the_body: 'the_body')
    @bg_received = HashWithIndifferentAccess.new(topic: 'transaction_received', event: { type: 'Buygoods Transaction' }).merge(@the_body)
    @b2b = HashWithIndifferentAccess.new(topic: 'transaction_received', event: { type: 'B2b Transaction' }).merge(@the_body)
    @m2m = HashWithIndifferentAccess.new(topic: 'transaction_received', event: { type: 'Merchant to Merchant Transaction' }).merge(@the_body)
    @bg_reversal = HashWithIndifferentAccess.new(topic: 'buygoods_transaction_reversed').merge(@the_body)
    @settlement = HashWithIndifferentAccess.new(topic: 'settlement_transfer_completed').merge(@the_body)
    @customer = HashWithIndifferentAccess.new(topic: 'customer_created').merge(@the_body)
    @stk = HashWithIndifferentAccess.new(topic: 'payment_request').merge(@the_body)
    @pay = HashWithIndifferentAccess.new(topic: 'pay_result').merge(@the_body)
  end
  context '#process' do
    it 'should raise an error if any of the the_body argument is empty' do
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

    it 'Process PAY Result' do
      expect { K2ProcessResult.process(@pay) }.not_to raise_error
    end
  end

  context '#check_topic' do
    it 'should raise an error if event_type is not specified' do
      expect { K2ProcessResult.check_topic(@the_body) }.to raise_error ArgumentError
    end
  end

  context '#return_hash' do
    it 'returns a hash object' do
      expect { K2ProcessResult.return_obj_hash(K2ProcessPay.new.components(@pay)) }.not_to raise_error
    end
  end
end
