# To add Bank Pay recipient
class K2BankPay < K2Pay
  # Adding PAY Recipients with either mobile_wallets or bank_accounts as destination of your payments.
  def add_recipient(params)
    # Validation
    params = validate_input(params, @exception_array += %w[first_name last_name phone email network pay_type currency value account_name bank_id bank_branch_id account_number])
    k2_request_pay_recipient = {
        name: "#{params[:pay_recipient][:first_name]} #{params[:last_name]}",
        account_name: params[:pay_recipient][:account_name],
        bank_id: params[:pay_recipient][:bank_id],
        bank_branch_id: params[:pay_recipient][:bank_branch_id],
        account_number: params[:pay_recipient][:account_number],
        email: validate_email(params[:pay_recipient][:email]),
        phone: validate_phone(params[:pay_recipient][:phone])
    }
    recipients_body = {
        type: params['pay_type'],
        pay_recipient: k2_request_pay_recipient
    }
    pay_recipient_hash = K2Pay.make_hash('api/v1/pay_recipients', 'post', @access_token, 'PAY', recipients_body)
    @threads << Thread.new do
      sleep 0.25
      @location_url = K2Connect.make_request(pay_recipient_hash)
    end
    @threads.each(&:join)
  end
end