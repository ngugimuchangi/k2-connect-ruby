RSpec.describe K2Entity do
  context "#initialize" do
    it 'should initialize with access_token' do
      expect { K2Entity.new("access_token") }.not_to raise_error
    end
  end
end
