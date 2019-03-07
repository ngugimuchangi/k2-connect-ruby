RSpec.describe K2Result do
  before(:all) do
    @k2result = K2Result.new
  end

  context "#components" do
    let(:the_body) { {the_body: "the_body"} }
    it 'should split body into components' do
      expect{ @k2result.components the_body }.not_to raise_error
    end
  end
end