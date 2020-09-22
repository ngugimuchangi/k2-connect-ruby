# For PAY/ Send Money to others
# TODO: Add K2Config configuration for the callback URL
# TODO: metadata vs meta_data
class K2Pay < K2Entity
  attr_reader :recipients_location_url, :payments_location_url

  # Adding PAY Recipients with either mobile_wallets or bank_accounts as destination of your payments.
  def add_recipient(params)
    params = params.with_indifferent_access
    @exception_array += %w[first_name last_name phone_number email type]
    # In the case of mobile pay
    if params[:type].eql?('mobile_wallet')
      params = validate_input(params, @exception_array += %w[network])
      k2_request_pay_recipient = {
        first_name: params[:first_name],
        last_name: params[:last_name],
        phone_number: validate_phone(params[:phone_number]),
        email: validate_email(params[:email]),
        network: params[:network]
      }
      # In the case of bank pay
    elsif params[:type].eql?('bank_account')
      params = validate_input(params, @exception_array += %w[account_name bank_ref bank_branch_ref account_number])
      k2_request_pay_recipient = {
          first_name: "#{params[:first_name]} #{params[:last_name]}",
          last_name: "#{params[:last_name]}",
          account_name: params[:account_name],
          bank_ref: params[:bank_ref],
          bank_branch_ref: params[:bank_branch_ref],
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
    pay_recipient_hash = make_hash(K2Config.path_url('pay_recipient'), 'post', @access_token, 'PAY', recipients_body)
    @threads << Thread.new do
      sleep 0.25
      @recipients_location_url = K2Connect.make_request(pay_recipient_hash)
    end
    @threads.each(&:join)
  end

  # Create an outgoing Payment to a third party.
  def create_payment(params)
    # Validation
    params = validate_input(params, @exception_array += %w[destination_reference destination_type currency value callback_url metadata])
    # The Request Body Parameters
    k2_request_pay_amount = {
      currency: params[:currency],
      value: params[:value]
    }
    k2_request_pay_metadata = params[:metadata]
    k2_request_links = {
        callback_url: params[:callback_url]
    }
    create_payment_body = {
      destination_reference: params[:destination_reference],
      destination_type: params[:destination_type],
      amount: k2_request_pay_amount,
      meta_data: k2_request_pay_metadata,
      _links: k2_request_links
    }
    create_payment_hash = make_hash(K2Config.path_url('payments'), 'post', @access_token, 'PAY', create_payment_body)
    @threads << Thread.new do
      sleep 0.25
      @payments_location_url = K2Connect.make_request(create_payment_hash)
    end
    @threads.each(&:join)
  end

  # Query/Check the status of a previously initiated PAY Payment request
  def query_status(method_type)
    if method_type.eql?('recipients')
      super('PAY', @recipients_location_url)
    elsif method_type.eql?('payments')
      super('PAY', @payments_location_url)
    end
  end

  # Query Location URL
  def query_resource(url)
    super('PAY', url)
  end
end
