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
    # before_action :judge_truth, only: [:initialize]

    # Initialize with a truth Value
    def initialize(truth_value)
      @truth_value = truth_value
    end

    # Confirm Truth value and carry out splitting
    def judge_truth(the_body)
      raise K2NilRequestBody if the_body.nil?
      if @truth_value
        request_body_components(the_body)
      else
        raise K2FalseTruthValue
      end
    rescue Exception => e
      puts(e.message)
    end

    # private :request_body_components
    # Check the Event Type
    def check_type(the_body)
      case
      when the_body.dig("topic").match?("buygoods_transaction_received")
        puts "Buygoods Transaction Received"
      when the_body.dig("topic").match?("buygoods_transaction_reversed")
        puts "Buygoods Transaction Reversed"
      when the_body.dig("topic").match?("settlement_transfer_completed")
        puts "Settlement"
      when the_body.dig("topic").match?("customer_created")
        puts "Customer Created"
      else
        puts "Nothing"
      end
    end

    # Splits the Body into the different elements of the request body. For Transaction Received.
    def request_body_components(the_body)
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
    rescue Exception => e
      puts(e.message)
    end

    # Splits the Body into the different elements of the request body. For Transaction Reversed.
    def transaction_reversed_components(the_body)
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
    rescue Exception => e
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
    rescue Exception => e
      puts(e.message)
    end

    # Splits the Body into the different elements of the request body. For Customer Created.
    def customer_created_components(the_body)
      @topic = the_body.dig("topic")
      @type = the_body.dig("event", "type")
      @msisdn = the_body.dig("event", "resource", "sender_msisdn")
      @first_name = the_body.dig("event", "resource", "sender_first_name")
      @middle_name = the_body.dig("event", "resource", "sender_middle_name")
      @last_name = the_body.dig("event", "resource", "sender_last_name")
    rescue Exception => e
      puts(e.message)
    end
  end
end