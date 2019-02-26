RSpec.describe "K2SplitRequest" do
  let(:k2_split) { K2SplitRequest.new("#truth_value")}

  subject { k2_split }

  it { should respond_to :judge_truth }
  it { should respond_to :request_body_components }

  describe "#judge_truth" do
    context 'Nil Request Body' do
      it 'should raise an error' do
        
      end
    end

    context 'Proper Request Body' do
      describe "#request_body_components" do
        it 'should divide request body into key components' do

        end
      end
    end
  end
end