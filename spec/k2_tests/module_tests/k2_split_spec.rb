RSpec.describe K2Split do
  context "#judge_truth" do
    let(:the_body) { HashWithIndifferentAccess.new(the_body: "the_body") }
    let(:truth_value) { true }
    it 'should raise an error if any of the the_body argument is empty' do
      raise K2EmptyRequestBody.new if the_body.nil? || the_body==""
      expect { raise K2EmptyRequestBody.new }.to raise_error K2EmptyRequestBody
    end

    it 'should raise an error if the truth_value is false' do
      raise K2FalseTruthValue unless truth_value
      expect { raise K2FalseTruthValue.new }.to raise_error K2FalseTruthValue
    end

    it 'should call on check_type if it passes the error checks' do
      allow(K2Split).to receive(:judge_truth).with(HashWithIndifferentAccess, true)
      K2Split.judge_truth(the_body, truth_value)
      expect(K2Split).to have_received(:judge_truth).with(HashWithIndifferentAccess, true)
    end
  end

  context "#check_type" do
    let(:the_body) { HashWithIndifferentAccess.new(the_body: "the_body", topic: "topic") }
    let(:truth_value) { true }
    it 'should raise an error if body is not a Hash' do
      expect { raise K2InvalidBody }.to raise_error K2InvalidBody
      # raise K2InvalidBody unless the_body.is_a?(Hash)
    end

    it 'should raise an error if event_type is not specified' do
      expect { raise K2UnspecifiedEvent.new }.to raise_error K2UnspecifiedEvent
      # raise K2UnspecifiedEvent.new if the_body.dig(:topic).nil?
    end
  end

  context "#return_hash" do
    it 'should return a Hash Object' do
      allow(K2Split).to receive(:return_hash).with(Object) { HashWithIndifferentAccess }
      expect(K2Split).to receive(:return_hash).with(Object)
      expect(K2Split.return_hash(Object)).to eq(HashWithIndifferentAccess)
      # K2Split.return_hash(Object)
    end
  end

end