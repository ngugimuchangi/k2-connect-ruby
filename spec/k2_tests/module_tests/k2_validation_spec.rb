include K2Validation
RSpec.describe K2Validation do
  let(:the_input) { { the_input: 'the_input', ze_input: 'ze_input' } }
  let(:array) { %w[the_input ze_input] }

  context '#validate_input' do
    it 'should raise an error if the_input parameters is empty' do
      expect { validate_input('', array) }.to raise_error ArgumentError
    end

    it 'should raise an error if the_input parameters is not of a Hash or Parameter class instance' do
      expect { validate_input('not a hash', array) }.to raise_error ArgumentError
    end

    it 'should raise an error if the_input parameters is an Integer' do
      expect { validate_input('not a hash', array) }.to raise_error ArgumentError
    end

    it 'should validate the_input with false is_query' do
      expect { validate_input(the_input, array) }.not_to raise_error
    end

    it 'should validate the_input with true is_query' do
      expect { validate_input(the_input, array) }.not_to raise_error
    end
  end

  context '#validate_hash' do
    let(:invalid_input) { { the_input: 'the_input', ze_input: '' } }
    let(:incorrect_input) { { the_input: 'the_input', za_input: 'ze_input' } }
    it 'should raise an error if the_input parameters are incorrect' do
      expect { validate_hash(incorrect_input, array) }.to raise_error K2IncorrectParams
    end

    it 'should raise an error if the_input has empty values' do
      expect { validate_hash(invalid_input, array) }.to raise_error K2EmptyParams
    end

    it 'should validate whether the hash input has the correct format' do
      expect { validate_hash(the_input, array) }.not_to raise_error
    end
  end

  context '#incorrect_keys' do
    let(:invalid_keys) { HashWithIndifferentAccess.new }
    it 'should check for any incorrect key formats' do
      expect { incorrect_keys(the_input, invalid_keys, array) }.not_to raise_error
    end
  end

  context '#nil_values' do
    let(:empty_keys) { HashWithIndifferentAccess.new }
    it 'should check for hash symbols with nil values' do
      expect { nil_values(the_input, empty_keys) }.not_to raise_error
    end
  end

  context '#validate_phone' do
    it 'should raise an error if length of phone number is wrong' do
      expect { validate_phone('+2547162309021') }.to raise_error ArgumentError
      expect { validate_phone('07162309021') }.to raise_error ArgumentError
    end

    it 'should validate phone number with country code' do
      expect { validate_phone('+254716230902') }.not_to raise_error
    end

    it 'should validate phone number without country code' do
      expect { validate_phone('0716230902') }.not_to raise_error
    end
  end

  context '#validate_email' do
    it 'should raise an error if email format is wrong' do
      expect { validate_email('email') }.to raise_error ArgumentError
    end

    it 'should validate the email' do
      expect { validate_email('david@d.com') }.not_to raise_error
    end
  end

  context '#convert_params' do
    it 'correct email format' do
      expect { convert_params(davod: 'daudi') }.not_to raise_error
    end
  end

  context '#validate_url' do
    it 'error for wrong url format' do
      url = 'url'
      expect { validate_url(url) }.to raise_error ArgumentError
    end

    it 'should validate the email' do
      expect { validate_url('https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/payment_requests') }.not_to raise_error
    end
  end
end
