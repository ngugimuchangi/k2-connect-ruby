RSpec.describe K2Entity do
  context '#initialize' do
    it 'should initialize with access_token' do
      expect { K2Entity.new('access_token') }.not_to raise_error
    end
  end

  context '#make_hash' do
    it 'should return a Hash' do
      expect { K2Entity.make_hash('path_url', 'request', 'access_token', 'class_type', 'body') }.not_to raise_error
      expect(K2Entity.make_hash('path_url', 'request', 'access_token', 'class_type', 'body')).to be_kind_of(Hash)
    end
  end
end
