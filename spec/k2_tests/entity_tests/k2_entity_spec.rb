RSpec.describe K2ConnectRuby::K2Entity::K2Entity do
  describe '#initialize' do
    it 'should initialize with access_token' do
      expect { K2ConnectRuby::K2Entity::K2Entity.new('access_token') }.not_to(raise_error)
    end
  end
end
