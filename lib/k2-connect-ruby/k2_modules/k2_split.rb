module K2Split
  # Confirm Truth value and carry out splitting
  def judge_truth(the_body)
    raise K2NilRequestBody.new if the_body.nil?
    if @truth_value
      check_type(the_body)
    else
      raise K2FalseTruthValue.new
    end
  rescue K2FalseTruthValue => k3
    puts(k3.message)
  rescue K2NilRequestBody => k2
    puts(k2.message)
    return k2.error
  rescue StandardError => e
    puts(e.message)
  end

  # Check the Event Type
  def check_type(the_body)
    if the_body.is_a?(Hash)
      case
      when the_body.dig("topic").match?("buygoods_transaction_received")
        received_components(the_body)
      when the_body.dig("topic").match?("buygoods_transaction_reversed")
        reversed_components(the_body)
      when the_body.dig("topic").match?("settlement_transfer_completed")
        settlement_components(the_body)
      when the_body.dig("topic").match?("customer_created")
        customer_components(the_body)
      when the_body.dig("topic").match?("payment_request")
        "STK Payments"
        stk_components(the_body)
      when the_body.dig("status").match?("Sent")
        "PAY Payments"
        pay_components(the_body)
      else
        raise K2UnspecifiedEvent.new
      end
    else
      raise K2InvalidBody
    end
  rescue K2InvalidBody => k2
    puts(k2.message)
  rescue K2UnspecifiedEvent => k3
    puts(k3.message)
  end
end