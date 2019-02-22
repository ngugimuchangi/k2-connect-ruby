class K2SplitRequest < K2Result
  attr_accessor

  # Splits the Body into the different elements of the request body. For Transaction Received.
  def received_components(the_body)
    @topic = the_body.dig("topic")
    @type = the_body.dig("event", "type")
    @reference_number = the_body.dig("event", "resource", "reference")
    @msisdn = the_body.dig("event", "resource", "sender_msisdn")
    @amount = the_body.dig("event", "resource", "amount")
    @currency = the_body.dig("event", "resource", "currency")
    @till_number = the_body.dig("event", "resource", "till_number")
    @system = the_body.dig("event", "resource", "system")
    @first_name = the_body.dig("event", "resource", "sender_first_name")
    @middle_name = the_body.dig("event", "resource", "sender_middle_name")
    @last_name = the_body.dig("event", "resource", "sender_last_name")
  rescue StandardError => e
    puts(e.message)
  end

  # Splits the Body into the different elements of the request body. For Transaction Reversed.
  def reversed_components(the_body)
    @topic = the_body.dig("topic")
    @type = the_body.dig("event", "type")
    @reference_number = the_body.dig("event", "resource", "reference")
    @origination_time = the_body.dig("event", "resource", "origination_time")
    @reversal_time = the_body.dig("event", "resource", "reversal_time")
    @msisdn = the_body.dig("event", "resource", "sender_msisdn")
    @amount = the_body.dig("event", "resource", "amount")
    @currency = the_body.dig("event", "resource", "currency")
    @till_number = the_body.dig("event", "resource", "till_number")
    @system = the_body.dig("event", "resource", "system")
    @first_name = the_body.dig("event", "resource", "sender_first_name")
    @middle_name = the_body.dig("event", "resource", "sender_middle_name")
    @last_name = the_body.dig("event", "resource", "sender_last_name")
  rescue StandardError => e
    puts(e.message)
  end

  # Splits the Body into the different elements of the request body. For Settlement Transfers.
  def settlement_components(the_body)
    @topic = the_body.dig("topic")
    @type = the_body.dig("event", "type")
    @reference_number = the_body.dig("event", "resource", "reference")
    @origination_time = the_body.dig("event", "resource", "origination_time")

  rescue StandardError => e
    puts(e.message)
  end

  # Splits the Body into the different elements of the request body. For Customer Created.
  def customer_components(the_body)
    @topic = the_body.dig("topic")
    @type = the_body.dig("event", "type")
    @msisdn = the_body.dig("event", "resource", "sender_msisdn")
    @first_name = the_body.dig("event", "resource", "sender_first_name")
    @middle_name = the_body.dig("event", "resource", "sender_middle_name")
    @last_name = the_body.dig("event", "resource", "sender_last_name")
  rescue StandardError => e
    puts(e.message)
  end

  # PAY Process Components
  def pay_components(the_body)

  end

  # STK Push Process Components
  def stk_components(the_body)

  end
end