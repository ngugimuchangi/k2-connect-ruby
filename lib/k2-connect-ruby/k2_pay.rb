class K2Pay
  attr_accessor :k2_response_pay,
                :postman_mock_server,
                :k2_access_token,
                :params_body

  def initialize(access_token)
    @k2_access_token = access_token
  end

  # Adding PAY Recipients with either mobile_wallets or bank_accounts as destination of your payments.
  # The Params from the form are passed through.
  def pay_recipients(pay_recipient_params)
    # The Request Body Parameters
    case
      # In the case of mobile pay
    when pay_recipient_params["pay_type"].match?("mobile_wallet")
      k2_request_pay_recipient = {
          "firstName": "#{pay_recipient_params["first_name"]}",
          "lastName": "#{pay_recipient_params["last_name"]}",
          "phone": "#{pay_recipient_params["phone"]}",
          "email": "#{pay_recipient_params["email"]}",
          "network": "#{pay_recipient_params["network"]}"
      }.to_json
      # In the case of bank pay
    when pay_recipient_params["pay_type"].match?("bank_account")
      k2_request_pay_recipient = {
          "name": "#{pay_recipient_params["first_name"]} #{pay_recipient_params["last_name"]}",
          "account_name": "#{pay_recipient_params["acc_name"]}",
          "bank_id": "#{pay_recipient_params["bank_id"]}",
          "bank_branch_id": "#{pay_recipient_params["bank_branch_id"]}",
          "account_number": "#{pay_recipient_params["acc_no"]}",
          "email": "#{pay_recipient_params["email"]}",
          "phone": "#{pay_recipient_params["phone"]}"
      }.to_json
    else
      # Add Custom error
      k2_request_pay_recipient = nil
    end
    recipients_body = {
        "type": "#{pay_recipient_params["pay_type"]}",
        "pay_recipient": k2_request_pay_recipient
    }.to_json
    K2ConnectRuby.to_connect(recipients_body, "/pay_recipients", @k2_access_token, false, false)
  end

  # Create an outgoing Payment to a third party.
  def pay_create(pay_create_params)
    # The Request Body Parameters
    k2_request_pay_amount = {
        "currency": "#{pay_create_params["currency"]}",
        "value": "#{pay_create_params["value"]}"
    }.to_json
    k2_request_pay_metadata = {
        "customerId": "8675309",
        "notes": "Salary payment for May 2018"
    }.to_json
    k2_request_pay_links = {
        "callback_url": "https://your-call-bak.yourapplication.com/payment_result"
    }.to_json
    pay_create_body = {
        "destination": "c7f300c0-f1ef-4151-9bbe-005005aa3747",
        "amount": k2_request_pay_amount,
        "metadata": k2_request_pay_metadata,
        "_links": k2_request_pay_links
    }.to_json
    K2ConnectRuby.to_connect(pay_create_body, "/payments", @k2_access_token, false, false)
  end

  # Process Pay Result Asynchronously after Payment is initiated
  def process_pay(the_request)
    raise K2NilRequest.new if the_request.nil?
    # The Response Body.
    @hash_body = Yajl::Parser.parse(the_request.body.string.as_json)
    # The Response Header
    @hash_header = Yajl::Parser.parse(the_request.headers.env.select{|k, _| k =~ /^HTTP_/}.to_json)
  rescue K2NilRequest => k2
    puts(k2.message)
  end

  # Query the status of a previously initiated Payment request
  def query_pay(id)
    query_body = {
        "ID": "#{id}"
    }.to_json
    K2ConnectRuby.to_connect(query_body, "/payments", @k2_access_token, false, true)
  end

end