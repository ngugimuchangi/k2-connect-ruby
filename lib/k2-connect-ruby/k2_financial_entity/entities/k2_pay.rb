# For PAY/ Send Money to others
# TODO: Add K2Config configuration for the callback URL
# TODO: metadata vs meta_data
class K2Pay < K2Entity
  attr_reader :recipients_location_url, :payments_location_url

  # Adding PAY Recipients with either mobile_wallets or bank_accounts as destination of your payments.
  def pay_recipients(params)
    params = params.with_indifferent_access
    @exception_array += %w[first_name last_name phone email type]
    # In the case of mobile pay
    if params[:type].eql?('mobile_wallet')
      params = validate_input(params, @exception_array += %w[network])
      k2_request_pay_recipient = {
        first_name: params[:first_name],
        last_name: params[:last_name],
        phone: validate_phone(params[:phone]),
        email: validate_email(params[:email]),
        network: params[:network]
      }
      # In the case of bank pay
    elsif params[:type].eql?('bank_account')
      params = validate_input(params, @exception_array += %w[account_name bank_id bank_branch_id account_number])
      k2_request_pay_recipient = {
          first_name: "#{params[:first_name]} #{params[:last_name]}",
          last_name: "#{params[:last_name]}",
          account_name: params[:account_name],
          bank_id: params[:bank_id],
          bank_branch_id: params[:bank_branch_id],
          account_number: params[:account_number],
          email: validate_email(params[:email]),
          phone: validate_phone(params[:phone])
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
    # params = params.with_indifferent_access
    # Validation
    params = validate_input(params, @exception_array += %w[destination currency value callback_url])
    # params = validate_input(params, @exception_array += %w[destination amount metadata _links])
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
        callback_url: params[:callback_url]
    }
    create_payment_body = {
      destination: params[:destination],
      amount: k2_request_pay_amount,
      meta_data: k2_request_pay_metadata,
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

  # Query Location URL
  def query_resource_url(url)
    super('PAY', url)
  end
end
