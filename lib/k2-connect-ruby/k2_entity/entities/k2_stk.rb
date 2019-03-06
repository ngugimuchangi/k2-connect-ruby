class K2Stk < K2Entity
  include K2Validation

  # Receive payments from M-PESA users.
  def receive_mpesa_payments(stk_receive_params)
    # Validation
    if validate_input(stk_receive_params, %w{ first_name last_name phone email currency value } )
      # The Request Body Parameters
      k2_request_subscriber = {
          first_name: stk_receive_params["first_name"],
          last_name: stk_receive_params["last_name"],
          phone: stk_receive_params["phone"],
          email: stk_receive_params["email"]
      }
      k2_request_amount = {
          currency: stk_receive_params["currency"],
          value: stk_receive_params["value"]
      }
      k2_request_metadata = {
          customer_id: 123456789,
          reference: 123456,
          notes: "Payment for invoice 12345"
      }
      receive_body = {
          payment_channel: "M-PESA",
          till_identifier: "444555",
          subscriber: k2_request_subscriber,
          amount: k2_request_amount,
          metadata: k2_request_metadata,
          call_back_url: "https://call_back_to_your_app.your_application.com"
      }
      receive_hash = K2Stk.hash_it("payment_requests", "POST", @access_token, "STK", receive_body)
      K2Connect.to_connect(receive_hash)
    end
  end

  # Query Payment Request Status
  def query_mpesa_payments(query_params)
    # Validation
    if validate_input(query_params, %w{ id })
      query_body = {
          ID: query_params[:id]
      }
      query_stk_hash = K2Stk.hash_it("payment_requests", "GET", @access_token, "STK", query_body)
      K2Connect.to_connect(query_stk_hash)
    end
  end
end