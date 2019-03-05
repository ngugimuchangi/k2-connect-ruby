RSpec.describe K2Entity do
  context "Object Creation" do
    it 'should initialize with access_token' do
      K2Entity.new("access_token")
    end
  end
end
