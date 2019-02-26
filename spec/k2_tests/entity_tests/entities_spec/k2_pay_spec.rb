RSpec.describe K2Pay do
  include K2Validation
  let!(:pay) { double() }

  it 'should include K2Validation Module' do
    expect(K2Pay).to include(K2Validation)
  end

  context "Adding PAY recipients" do
    let(:params) { {first_name: "first_name" ,last_name: "last_name", phone: "phone", email: "email", currency:"currency", value:"value"} }
    it 'should validate user input' do
      expect(params).to be_a_kind_of(Hash)
      expect(validate_input).to
    end
  end

  context "Create outgoing PAyment to Third Party" do

  end

  context "Query PAYment Request Status" do

  end
end