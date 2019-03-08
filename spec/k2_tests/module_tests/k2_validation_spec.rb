include K2Validation
RSpec.describe K2Validation do
  let(:the_input) { {the_input: "the_input", ze_input: "ze_input"} }
  let(:array) { %w{the_input ze_input} }

  context "#validate_input" do
    let(:not_hash) { "not a hash" }
    it 'should raise an error if the_input parameters is empty' do
      expect { validate_input("", array) }.to raise_error ArgumentError
    end

    it 'should raise an error if the_input parameters is not of a Hash or Parameter class instance' do
      expect { validate_input(not_hash, array) }.to raise_error ArgumentError
    end

    it 'should validate the_input with false is_query' do
      expect{ validate_input(the_input, array) }.not_to raise_error
    end

    it 'should validate the_input with true is_query' do
      expect{ validate_input(the_input, array) }.not_to raise_error
    end
  end

  context "#validate_hash" do
    let(:invalid_input) { {the_input: "the_input", ze_input: ""} }
    let(:incorrect_input) { {the_input: "the_input", za_input: "ze_input"} }
    it 'should raise an error if the_input parameters are incorrect' do
      expect { validate_hash(incorrect_input, array) }.to raise_error IncorrectParams
    end

    it 'should raise an error if the_input has empty values' do
      expect { validate_hash(invalid_input, array) }.to raise_error K2InvalidHash
    end

    it 'should validate whether the hash input has the correct format' do
      expect{ validate_hash(the_input, array) }.not_to raise_error
    end
  end

  context "#incorrect_keys" do
    let(:invalid_keys) { HashWithIndifferentAccess.new }
    it 'should check for any incorrect key formats' do
      expect{ incorrect_keys(the_input, invalid_keys, array) }.not_to raise_error
    end
  end

  context "#nil_params" do
    let(:empty_keys) { HashWithIndifferentAccess.new }
    it 'should check for hash symbols with nil values' do
      expect{ nil_params(the_input, empty_keys) }.not_to raise_error
    end
  end

end