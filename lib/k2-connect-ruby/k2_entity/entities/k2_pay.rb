class K2Pay < K2Entity
  include K2Validation

  # Adding PAY Recipients with either mobile_wallets or bank_accounts as destination of your payments.
  def pay_recipients(pay_recipient_params)
    # Validation
    if validate_input(pay_recipient_params, %w{ first_name last_name phone email network pay_type currency value acc_name bank_id bank_branch_id acc_no })
      # The Request Body Parameters
      # In the case of mobile pay
      if  pay_recipient_params["pay_type"].eql?("mobile_wallet")
        k2_request_pay_recipient = {
            firstName: pay_recipient_params["first_name"],
            lastName: pay_recipient_params["last_name"],
            phone: pay_recipient_params["phone"],
            email: pay_recipient_params["email"],
            network: pay_recipient_params["network"]
        }
      else
        # In the case of bank pay
        k2_request_pay_recipient = {
            name: "#{pay_recipient_params["first_name"]} #{pay_recipient_params["last_name"]}",
            account_name: pay_recipient_params["acc_name"],
            bank_id: pay_recipient_params["bank_id"],
            bank_branch_id: pay_recipient_params["bank_branch_id"],
            account_number: pay_recipient_params["acc_no"],
            email: pay_recipient_params["email"],
            phone: pay_recipient_params["phone"]
        }
      end
      recipients_body = {
          type: pay_recipient_params["pay_type"],
          pay_recipient: k2_request_pay_recipient
      }
      pay_recipient_hash = K2Pay.hash_it("pay_recipients", "POST", @access_token, "PAY", recipients_body)
      K2Connect.to_connect(pay_recipient_hash)
    end
  end

  # Create an outgoing Payment to a third party.
  def pay_create(pay_create_params)
    # Validation
    if validate_input(pay_create_params, %w{ currency value })
      # The Request Body Parameters
      k2_request_pay_amount = {
          currency: pay_create_params["currency"],
          value: pay_create_params["value"]
      }
      k2_request_pay_metadata = {
          customerId: 8675309,
          notes: "Salary payment for May 2018"
      }
      pay_create_body = {
          destination: "c7f300c0-f1ef-4151-9bbe-005005aa3747",
          amount: k2_request_pay_amount,
          metadata: k2_request_pay_metadata,
          callback_url: "https://your-call-bak.yourapplication.com/payment_result"
      }
      pay_create_hash = K2Pay.hash_it("payments", "POST", @access_token,"PAY", pay_create_body)
      K2Connect.to_connect(pay_create_hash)
    end
  end

  # Query the status of a previously initiated Payment request
  def query_pay(query_params)
    # Validation
    if validate_input(query_params, %w{ id })
      query_body = {
          ID: query_params[:id]
      }
      query_pay_hash = K2Pay.hash_it("payments", "GET", @access_token, "PAY", query_body)
      K2Connect.to_connect(query_pay_hash)
    end
  end
end