RSpec.describe K2Payment do
  before(:all) do
    @k2payment = K2Payment.new
  end

  context "#components" do
    let(:the_body) { {the_body: "the_body"} }
    it 'should split body into components' do
      allow(@k2payment).to receive(:components).with(Hash)
      @k2payment.components(the_body)
      expect(@k2payment).to have_received(:components).with(Hash)
    end
  end
end

RSpec.describe K2ProcessStk do
  before(:all) do
    @k2processstk = K2ProcessStk.new
  end

  context "#components" do
    let(:the_body) { {the_body: "the_body"} }
    it 'should split body into components' do
      allow(@k2processstk).to receive(:components).with(Hash)
      @k2processstk.components(the_body)
      expect(@k2processstk).to have_received(:components).with(Hash)
    end
  end
end

RSpec.describe K2ProcessPay do
  before(:all) do
    @k2processpay = K2ProcessPay.new
  end

  context "#components" do
    let(:the_body) { {the_body: "the_body"} }
    it 'should split body into components' do
      allow(@k2processpay).to receive(:components).with(Hash)
      @k2processpay.components(the_body)
      expect(@k2processpay).to have_received(:components).with(Hash)
    end
  end
end