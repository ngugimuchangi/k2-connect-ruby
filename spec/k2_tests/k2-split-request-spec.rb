RSpec.describe "K2SplitRequest" do
  let(:k2_split) { K2ConnectRuby::K2SplitRequest.new("#truth_value")}

  subject { k2_split }

  it { should respond_to :judge_truth }
  it { should respond_to :request_body_components }

  describe "#judge_truth" do

    describe "#request_body_components" do

    end
  end
end