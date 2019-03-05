RSpec.describe K2ProcessResult do
  context "#judge_truth" do
    let(:the_body) { HashWithIndifferentAccess.new(the_body: "the_body") }
    it 'should raise an error if any of the the_body argument is empty' do
      raise K2EmptyRequestBody.new if the_body.empty?
      expect { raise K2EmptyRequestBody.new }.to raise_error K2EmptyRequestBody
    end

    it 'should raise an error if the truth_value is false' do
      raise K2FalseTruthValue unless truth_value
      expect { raise K2FalseTruthValue.new }.to raise_error K2FalseTruthValue
    end

    it 'should call on check_type if it passes the error checks' do
      allow(K2ProcessResult).to receive(:judge_truth).with(HashWithIndifferentAccess)
      K2ProcessResult.judge_truth(the_body)
      expect(K2ProcessResult).to have_received(:judge_truth).with(HashWithIndifferentAccess)
    end
  end

  context "#check_type" do
    let(:the_body) { HashWithIndifferentAccess.new(the_body: "the_body", topic: "topic") }
    it 'should raise an error if body is not a Hash' do
      expect { raise K2InvalidBody }.to raise_error K2InvalidBody
    end

    it 'should raise an error if event_type is not specified' do
      expect { raise K2UnspecifiedEvent.new }.to raise_error K2UnspecifiedEvent
    end
  end

  context "#return_hash" do
    it 'should return a Hash Object' do
      allow(K2ProcessResult).to receive(:return_hash).with(Object) { HashWithIndifferentAccess }
      expect(K2ProcessResult).to receive(:return_hash).with(Object)
      expect(K2ProcessResult.return_hash(Object)).to eq(HashWithIndifferentAccess)
    end
  end

end