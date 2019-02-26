RSpec.describe K2Entity do
  context "Object Creation" do
    it 'should initialize with access_token' do
      access_token = "Access Token"
      entity = K2Entity.new(access_token)
      expect(entity.access_token).to eq(access_token)
    end
  end
end
