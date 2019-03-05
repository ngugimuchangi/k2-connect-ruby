RSpec.describe K2ProcessResult do
  context "#judge_truth" do
    let(:the_body) { HashWithIndifferentAccess.new(the_body: "the_body") }
    it 'should raise an error if any of the the_body argument is empty' do
      expect { K2ProcessResult.process("") }.to raise_error ArgumentError
    end

    it 'should call on check_type if it passes the error checks' do
      allow(K2ProcessResult).to receive(:process).with(HashWithIndifferentAccess)
      K2ProcessResult.process(the_body)
      expect(K2ProcessResult).to have_received(:process).with(HashWithIndifferentAccess)
    end
  end

  context "#check_type" do
    let(:the_body) { HashWithIndifferentAccess.new(the_body: "the_body", topic: "topic") }

    it 'should raise an error if event_type is not specified' do
      expect { K2ProcessResult.check_type(the_body) }.to raise_error ArgumentError
    end
  end

  context "#return_hash" do
    it 'should return a Hash Object' do
      allow(K2ProcessResult).to receive(:return_hash).with(Object) { HashWithIndifferentAccess }
      K2ProcessResult.return_hash(Object)
      expect(K2ProcessResult.return_hash(Object)).to eq(HashWithIndifferentAccess)
    end
  end

end