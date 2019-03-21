# For PAY/ Send Money to others
class K2Pay < K2Entity
  attr_reader :location_url

  # Adding PAY Recipients with either mobile_wallets or bank_accounts as destination of your payments.
  def pay_recipients(params)
    # Validation
    params = validate_input(params, @exception_array += %w[first_name last_name phone email network pay_type currency value account_name bank_id bank_branch_id account_number])
    # In the case of mobile pay
    if params['pay_type'].eql?('mobile_wallet')
      k2_request_pay_recipient = {
        firstName: params['first_name'],
        lastName: params['last_name'],
        phone: validate_phone(params['phone']),
        email: validate_email(params['email']),
        network: params['network']
      }
    elsif params['pay_type'].eql?('bank_account')
      # In the case of bank pay
      k2_request_pay_recipient = {
        name: "#{params['first_name']} #{params['last_name']}",
        account_name: params['account_name'],
        bank_id: params['bank_id'],
        bank_branch_id: params['bank_branch_id'],
        account_number: params['account_number'],
        email: validate_email(params['email']),
        phone: validate_phone(params['phone'])
      }
    else
      raise ArgumentError, 'Undefined Payment Method.'
    end
    recipients_body = {
      type: params['pay_type'],
      pay_recipient: k2_request_pay_recipient
    }
    pay_recipient_hash = K2Pay.make_hash('pay_recipients', 'POST', @access_token, 'PAY', recipients_body)
    @threads << Thread.new do
      sleep 0.25
      @location_url = K2Connect.to_connect(pay_recipient_hash)
    end
    @threads.each(&:join)
  end

  # Create an outgoing Payment to a third party.
  def create_payment(params)
    # Validation
    params = validate_input(params, @exception_array += %w[currency value])
    # The Request Body Parameters
    k2_request_pay_amount = {
      currency: params['currency'],
      value: params['value']
    }
    k2_request_pay_metadata = {
      customerId: 8_675_309,
      notes: 'Salary payment for May 2018'
    }
    create_payment_body = {
      destination: 'c7f300c0-f1ef-4151-9bbe-005005aa3747',
      amount: k2_request_pay_amount,
      metadata: k2_request_pay_metadata,
      callback_url: 'https://your-call-bak.yourapplication.com/payment_result'
    }
    create_payment_hash = K2Pay.make_hash('payments', 'POST', @access_token, 'PAY', create_payment_body)
    @threads << Thread.new do
      sleep 0.25
      @location_url = K2Connect.to_connect(create_payment_hash)
    end
    @threads.each(&:join)
  end

  # Query/Check the status of a previously initiated PAY Payment request
  def query_status(path_url, class_type = 'PAY')
    super
  end
end
