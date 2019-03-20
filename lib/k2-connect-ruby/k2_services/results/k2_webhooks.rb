# Common Structure for Webhook Results
  class K2Webhook < K2Result
    attr_reader :msisdn,
                :link_resource

    def components(the_body)
      super
      @link_resource = the_body.dig('_links', 'resource')
    end
  end

  # For The Customer Created Webhook
  class CustomerCreated < K2Webhook
    def components(the_body)
      super
      @msisdn = the_body.dig('event', 'resource', 'msisdn')
      @last_name = the_body.dig('event', 'resource', 'last_name')
      @first_name = the_body.dig('event', 'resource', 'first_name')
      @middle_name = the_body.dig('event', 'resource', 'middle_name')
    end
  end

  # For The General Webhook except Customer Created Result
  class GeneralWebhook < K2Webhook
    attr_reader :reference,
                :origination_time,
                :resource_status

    def components(the_body)
      super
      @amount = the_body.dig('event', 'resource', 'amount')
      @currency = the_body.dig('event', 'resource', 'currency')
      @reference = the_body.dig('event', 'resource', 'reference')
      @resource_status = the_body.dig('event', 'resource', 'status')
      @origination_time = the_body.dig('event', 'resource', 'origination_time')
    end
  end

  # For Settlement Transfer Webhook
  class Settlement < GeneralWebhook
    attr_reader :destination,
                :destination_type,
                :transfer_time,
                :transfer_type,
                :destination_mm_system

    def components(the_body)
      super
      @destination = the_body.dig('event', 'resource', 'destination')
      @transfer_time = the_body.dig('event', 'resource', 'transfer_time')
      @transfer_type = the_body.dig('event', 'resource', 'transfer_type')
      @msisdn = the_body.dig('event', 'resource', 'destination', 'msisdn')
      @destination_type = the_body.dig('event', 'resource', 'destination', 'type')
      @destination_mm_system = the_body.dig('event', 'resource', 'destination', 'mm_system')
    end

   # For The Common Transaction Webhook
  class K2Transaction < GeneralWebhook
    attr_reader :till_number,
                :system

    def components(the_body)
      super
      @system = the_body.dig('event', 'resource', 'system')
      @msisdn = the_body.dig('event', 'resource', 'sender_msisdn')
      @till_number = the_body.dig('event', 'resource', 'till_number')
      @last_name = the_body.dig('event', 'resource', 'sender_last_name')
      @first_name = the_body.dig('event', 'resource', 'sender_first_name')
      @middle_name = the_body.dig('event', 'resource', 'sender_middle_name')
    end
  end

   # For The BuyGoods Reversed Webhook
  class Reversal < K2Transaction
    attr_reader :reversal_time
    def components(the_body)
      super
      @reversal_time = the_body.dig('event', 'resource', 'reversal_time')
    end
  end

   # For The BuyGoods Received Webhook
  class BuyGoods < K2Transaction
    def components(the_body)
      super
    end
  end

   # For The External Till to Till transaction
  class B2B < K2Transaction
    attr_reader :sending_till
    def components(the_body)
      super
      @sending_till = the_body.dig('event', 'resource', 'sending_till')
    end
  end

   # For The Merchant to Merchant Transaction Received
  class MerchantTransaction < K2Transaction
    attr_reader :sending_merchant
    def components(the_body)
      super
      @sending_merchant = the_body.dig('event', 'resource', 'sending_merchant')
    end
  end
end
