# For PAY/ Send Money to others
# TODO: Add K2Config configuration for the callback URL
# TODO: metadata vs meta_data
class K2Pay < K2Entity
  attr_reader :recipients_location_url, :payments_location_url

  # Adding PAY Recipients with either mobile_wallets or bank_accounts as destination of your payments.
  def pay_recipients(params)
    # Validation
    #params = validate_input(params, @exception_array += %w[first_name last_name phone email network pay_type currency value account_name bank_id bank_branch_id account_number])
    params = validate_input(params, @exception_array += %w[type pay_recipient])
    # In the case of mobile pay
    # if params['pay_type'].eql?('mobile_wallet')
    if params[:type].eql?('mobile_wallet')
      #puts "Phone: #{params[:pay_recipient][:phone]}"
      #puts "Validated Phone: #{validate_phone(params[:pay_recipient][:phone])}"
      k2_request_pay_recipient = {
        first_name: params[:pay_recipient][:first_name],
        last_name: params[:pay_recipient][:last_name],
        phone: validate_phone(params[:pay_recipient][:phone]),
        email: validate_email(params[:pay_recipient][:email]),
        network: params[:pay_recipient][:network]
      }
      #puts "Pay Recipient: #{k2_request_pay_recipient}"
    #elsif params['pay_type'].eql?('bank_account')
    elsif params[:type].eql?('bank_account')
      # In the case of bank pay
      k2_request_pay_recipient = {
        name: "#{params[:pay_recipient][:first_name]} #{params[:last_name]}",
        account_name: params[:pay_recipient][:account_name],
        bank_id: params[:pay_recipient][:bank_id],
        bank_branch_id: params[:pay_recipient][:bank_branch_id],
        account_number: params[:pay_recipient][:account_number],
        email: validate_email(params[:pay_recipient][:email]),
        phone: validate_phone(params[:pay_recipient][:phone])
      }
    else
      raise ArgumentError, 'Undefined Payment Method.'
    end
    recipients_body = {
      type: params[:type],
      #type: params['pay_type'],
      pay_recipient: k2_request_pay_recipient
    }
    pay_recipient_hash = K2Pay.make_hash('api/v1/pay_recipients', 'POST', @access_token, 'PAY', recipients_body)
    @threads << Thread.new do
      sleep 0.25
      @recipients_location_url = K2Connect.connect(pay_recipient_hash)
    end
    @threads.each(&:join)
  end

  # Create an outgoing Payment to a third party.
  def create_payment(params)
    # Validation
    #params = validate_input(params, @exception_array += %w[currency value])
    params = validate_input(params, @exception_array += %w[destination amount metadata _links])
    # The Request Body Parameters
    k2_request_pay_amount = {
      currency: params[:currency],
      value: params[:value]
    }
    k2_request_pay_metadata = {
      customerId: '8_675_309',
      notes: 'Salary payment for May 2018'
    }
    k2_request_links = {
        call_back_url: params[:callback_url]
    }
    create_payment_body = {
      destination: 'c7f300c0-f1ef-4151-9bbe-005005aa3747',
      amount: k2_request_pay_amount,
      metadata: k2_request_pay_metadata,
      _links: k2_request_links
    }
    create_payment_hash = K2Pay.make_hash('api/v1/payments', 'POST', @access_token, 'PAY', create_payment_body)
    @threads << Thread.new do
      sleep 0.25
      @payments_location_url = K2Connect.connect(create_payment_hash)
    end
    @threads.each(&:join)
  end

  # Query/Check the status of a previously initiated PAY Payment request
  def query_status(path_url)
    super('PAY', path_url)
  end
end
