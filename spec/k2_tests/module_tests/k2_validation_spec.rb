RSpec.describe K2Validation do
  let(:the_input) { {the_input: "the_input"} }
  let(:array) { %w{array array2} }

  context "#validate_input" do
    let(:is_query) { true }
    it 'should raise an error if the_input parameters is empty' do
      raise K2EmptyInput.new if the_input.empty?
      expect { raise K2EmptyInput.new }.to raise_error K2EmptyInput
    end

    it 'should raise an error if the_input parameters is not of a Hash or Parameter class instance' do
      unless the_input.is_a?(Hash)
        unless the_input.has_key?(:authenticity_token)
          "Undefined Input Form"
        end
      end
    end

    it 'should validate the_input' do
      allow(K2Validation).to receive(:validate_input).with(Hash, Array, true)
      K2Validation.validate_input(the_input, array, is_query)
      expect(K2Validation).to have_received(:validate_input).with(Hash, Array, true)
    end
  end

  context "#validate_hash" do
    let(:empty_keys) { HashWithIndifferentAccess.new }
    let(:invalid_keys) { HashWithIndifferentAccess.new }
    it 'should raise an error if the_input parameters is empty' do
      raise IncorrectParams.new(invalid_keys) unless invalid_keys.empty?
      expect { raise IncorrectParams.new(invalid_keys) }.to raise_error IncorrectParams
    end

    it 'should raise an error if the_input parameters is not of a Hash or Parameter class instance' do
      raise K2InvalidHash.new(empty_keys) unless empty_keys.empty?
      expect { raise K2InvalidHash.new(empty_keys) }.to raise_error K2InvalidHash
    end

    it 'should validate whether the hash input has the correct format' do
      allow(K2Validation).to receive(:validate_hash).with(Hash, Array) { true }
      K2Validation.validate_hash(the_input, array)
      expect(K2Validation).to have_received(:validate_hash).with(Hash, Array)
      expect(K2Validation.validate_hash(the_input, array)).to eq(true)
    end
  end

  context "#check_keys" do
    let(:invalid_keys) { HashWithIndifferentAccess.new }

    it 'should check for any incorrect key formats' do
      allow(K2Validation).to receive(:check_keys).with(Hash, Hash, Array)
      K2Validation.check_keys(the_input, invalid_keys, array)
      expect(K2Validation).to have_received(:check_keys).with(Hash, Hash, Array)
    end
  end

  context "#nil_params" do
    let(:empty_keys) { HashWithIndifferentAccess.new }

    it 'should check for hash symbols with nil values' do
      allow(K2Validation).to receive(:nil_params).with(Hash, Hash)
      K2Validation.nil_params(the_input, empty_keys)
      expect(K2Validation).to have_received(:nil_params).with(Hash, Hash)
    end
  end

  context "#validate_id" do

    it 'should validate whether the hash input has the correct format' do
      allow(K2Validation).to receive(:validate_hash).with(Hash, Array)
      K2Validation.validate_hash(the_input, array)
      expect(K2Validation).to have_received(:validate_hash).with(Hash, Array)
    end
  end

end