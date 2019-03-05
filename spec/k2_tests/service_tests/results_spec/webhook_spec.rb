RSpec.describe WebhookTransaction do
  before(:all) do
    @k2webhooktransaction = WebhookTransaction.new
  end

  context "#components" do
    let(:the_body) { {the_body: "the_body"} }
    it 'should split body into components' do
      allow(@k2webhooktransaction).to receive(:components).with(Hash)
      @k2webhooktransaction.components(the_body)
      expect(@k2webhooktransaction).to have_received(:components).with(Hash)
    end
  end
end

RSpec.describe CommonWebhook do
  before(:all) do
    @k2commonwebhook = CommonWebhook.new
  end

  context "#components" do
    let(:the_body) { {the_body: "the_body"} }
    it 'should split body into components' do
      allow(@k2commonwebhook).to receive(:components).with(Hash)
      @k2commonwebhook.components(the_body)
      expect(@k2commonwebhook).to have_received(:components).with(Hash)
    end
  end
end

RSpec.describe CustomerCreated do
  before(:all) do
    @k2customercreated = CustomerCreated.new
  end

  context "#components" do
    let(:the_body) { {the_body: "the_body"} }
    it 'should split body into components' do
      allow(@k2customercreated).to receive(:components).with(Hash)
      @k2customercreated.components(the_body)
      expect(@k2customercreated).to have_received(:components).with(Hash)
    end
  end
end

RSpec.describe BuyGoods do
  before(:all) do
    @k2buygoods = BuyGoods.new
  end

  context "#components" do
    let(:the_body) { {the_body: "the_body"} }
    it 'should split body into components' do
      allow(@k2buygoods).to receive(:components).with(Hash)
      @k2buygoods.components(the_body)
      expect(@k2buygoods).to have_received(:components).with(Hash)
    end
  end
end

RSpec.describe Reversal do
  before(:all) do
    @k2reversal = Reversal.new
  end

  context "#components" do
    let(:the_body) { {the_body: "the_body"} }
    it 'should split body into components' do
      allow(@k2reversal).to receive(:components).with(Hash)
      @k2reversal.components(the_body)
      expect(@k2reversal).to have_received(:components).with(Hash)
    end
  end
end

RSpec.describe Settlement do
  before(:all) do
    @k2result = Settlement.new
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

