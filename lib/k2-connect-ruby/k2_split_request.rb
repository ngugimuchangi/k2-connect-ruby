module K2ConnectRuby
  class K2SplitRequest
    attr_accessor :topic,
                  :reference_number,
                  :origination_time,
                  :reversal_time,
                  :msisdn,
                  :amount,
                  :currency,
                  :till_number,
                  :system,
                  :first_name,
                  :middle_name,
                  :last_name,
                  :type,
                  :truth_value,
                  :transfer_time,
                  :transfer_type,
                  :status,
                  :destination_type,
                  :destination_msisdn,
                  :destination_mm_system

    # Initialize with a truth Value
    def initialize(truth_value)
      raise K2NilTruthValue if truth_value.nil?
      raise K2InvalidTruthValue unless !!truth_value == truth_value
      @truth_value = truth_value
    rescue K2InvalidTruthValue => k3
      puts(k3.message)
    rescue K2NilTruthValue => k2
      puts(k2.message)
    end

    # Confirm Truth value and carry out splitting
    def judge_truth(the_body)
      raise K2NilRequestBody.new if the_body.nil?
      raise K2FalseTruthValue.new unless @truth_value
      check_type(the_body)
      # request_body_components(the_body) if @truth_value
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
      raise K2InvalidBody unless the_body.is_a?(Hash)
      case
      when the_body.dig("topic").match?("buygoods_transaction_received")
        received_components(the_body)
      when the_body.dig("topic").match?("buygoods_transaction_reversed")
        reversed_components(the_body)
      when the_body.dig("topic").match?("settlement_transfer_completed")
        settlement_components(the_body)
      when the_body.dig("topic").match?("customer_created")
        customer_components(the_body)
      else
        raise K2UnspecifiedEvent.new
      end
    rescue K2InvalidBody => k2
      puts(k2.message)
    rescue K2UnspecifiedEvent => k3
      puts(k3.message)
    end

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
      @msisdn = the_body.dig("event", "resource", "sender_msisdn")
      @amount = the_body.dig("event", "resource", "amount")
      @currency = the_body.dig("event", "resource", "currency")
      @transfer_time = the_body.dig("event", "resource", "transfer_time")
      @transfer_type = the_body.dig("event", "resource", "transfer_type")
      @status = the_body.dig("event", "resource", "status")
      @destination_type = the_body.dig("event", "resource", "destination", "type")
      @destination_msisdn = the_body.dig("event", "resource", "destination", "msisdn")
      @destination_mm_system = the_body.dig("event", "resource", "destination", "mm_system")
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
  end
end