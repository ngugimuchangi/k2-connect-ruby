RSpec.describe K2Result do
  before(:all) do
    @k2result = K2Result.new
  end

  context "#components" do
    let(:the_body) { {the_body: "the_body"} }
    it 'should split body into components' do
      allow(@k2result).to receive(:components).with(Hash)
      @k2result.components(the_body)
      expect(@k2result).to have_received(:components).with(Hash)
    end
  end
end