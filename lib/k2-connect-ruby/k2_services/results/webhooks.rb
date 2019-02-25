class WebhookTransaction < K2Result
  # Can also implement Customer Created from Here
  attr_accessor :msisdn,
                :first_name,
                :middle_name,
                :last_name

  class CommonWebhook < WebhookTransaction
    attr_accessor :reference,
                  :origination_time,
                  :status

    # For The General Webhook
    def components(the_body)
      super components(the_body)
      K2CommonWebhook.components(the_body, @amount, @currency, @reference, @origination_time, @status)
    end

  end

  class Customer_Created < WebhookTransaction
    # For The Customer Created Webhook
    def components(the_body)
      super components(the_body)
      @msisdn = the_body.dig("event", "resource", "msisdn")
      @first_name = the_body.dig("event", "resource", "first_name")
      @middle_name = the_body.dig("event", "resource", "middle_name")
      @last_name = the_body.dig("event", "resource", "last_name")
    end
  end

  class BuyGoods < CommonWebhook
    attr_accessor :till_number,
                  :system

    # For The BuyGoods Received Webhook
    def components(the_body)
      super components(the_body)
      K2BuyGoods.components(the_body, @msisdn, @till_number, @system, @first_name, @middle_name, @last_name)
    end

    class Reversal < BuyGoods
      attr_accessor :reversal_time
      # For The BuyGoods Reversed Webhook
      def components(the_body)
        super components(the_body)
        @reversal_time = the_body.dig("event", "resource", "reversal_time")
      end

    end

  end

  class Settlement < CommonWebhook
    attr_accessor :destination,
                  :destination_type,
                  :transfer_time,
                  :transfer_type,
                  :destination_mm_system
    # For The Settlement Transfer Webhook
    def components(the_body)
      super components(the_body)
      @transfer_time = the_body.dig("event", "resource", "transfer_time")
      @transfer_type = the_body.dig("event", "resource", "transfer_type")
      @destination = the_body.dig("event", "resource", "destination")
      @destination_type = the_body.dig("event", "resource", "destination", "type")
      @msisdn = the_body.dig("event", "resource", "destination", "msisdn")
      @destination_mm_system = the_body.dig("event", "resource", "destination", "mm_system")
    end

  end

end