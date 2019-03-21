RSpec.describe K2Config do
  context '#set_host_url' do
    it 'should raise error if not a url' do
      expect { K2Config.set_host_url('url') }.to raise_error ArgumentError
    end
    it 'should set the url' do
      expect { K2Config.set_host_url('http://test.com') }.not_to raise_error
    end
  end

  context '#get_host_url' do
    it 'should retrieve a url' do
      expect { K2Config.get_host_url }.not_to raise_error
    end
  end
end
