RSpec.describe K2ProcessResult do
  let(:the_body) { HashWithIndifferentAccess.new(the_body: "the_body", topic: "topic") }
  context "#process" do
    let(:bg_received) { HashWithIndifferentAccess.new(the_body: "the_body", topic: "buygoods_transaction_received") }
    let(:bg_reversal) { HashWithIndifferentAccess.new(the_body: "the_body", topic: "buygoods_transaction_reversed") }
    let(:settlement) { HashWithIndifferentAccess.new(the_body: "the_body", topic: "settlement_transfer_completed") }
    let(:customer) { HashWithIndifferentAccess.new(the_body: "the_body", topic: "customer_created") }
    let(:stk) { HashWithIndifferentAccess.new(the_body: "the_body", topic: "payment_request") }
    let(:pay) { HashWithIndifferentAccess.new(the_body: "the_body", topic: "pay_result") }

    it 'should raise an error if any of the the_body argument is empty' do
      expect { K2ProcessResult.process("") }.to raise_error ArgumentError
    end

    it 'Buy Goods Received' do
      expect { K2ProcessResult.process(bg_received) }.not_to raise_error
    end

    it 'Buy Goods Reversed' do
      expect { K2ProcessResult.process(bg_reversal) }.not_to raise_error
    end

    it 'Settlement Transfer Completed' do
      expect { K2ProcessResult.process(settlement) }.not_to raise_error
    end

    it 'Customer Created' do
      expect { K2ProcessResult.process(customer) }.not_to raise_error
    end

    it 'Process Stk Result' do
      expect { K2ProcessResult.process(stk) }.not_to raise_error
    end

    it 'Process PAY Result' do
      expect { K2ProcessResult.process(pay) }.not_to raise_error
    end
  end

  context "#check_topic" do
    it 'should raise an error if event_type is not specified' do
      expect { K2ProcessResult.check_topic(the_body) }.to raise_error ArgumentError
    end
  end

  context "#return_hash" do
    let(:pay) { HashWithIndifferentAccess.new(the_body: "the_body", topic: "pay_result") }
    it 'returns a hash object' do
      expect { K2ProcessResult.return_array(K2ProcessPay.new.components(pay)) }.not_to raise_error
    end
  end

end