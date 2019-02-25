class K2Payment < K2Result
  attr_accessor :metadata,
                :customer_id,
                :notes,
                :self,
                :status,
                :reference,
                :origination_time,
                :status,
                :first_name,
                :middle_name,
                :last_name

  def components(the_body)
    @metadata = the_body.dig("metadata")
    @customer_id = the_body.dig("metadata", "customer_id")
    @notes = the_body.dig("metadata", "notes")
    @self = the_body.dig("_links", "self")
  end

  class K2ProcessStk < K2Payment
    attr_accessor :payment_request,
                  :metadata_reference,
                  :link_resource,
                  :resource_status,
                  :errors,
                  :msisdn,
                  :till_number,
                  :system

    def components(the_body)
      super components the_body
      @status = the_body.dig("status")
      @payment_request = the_body.dig("_links", "payment_request")
      @metadata_reference = the_body.dig("metadata", "reference")
      @link_resource = the_body.dig("_links", "resource")
      @errors = the_body.dig("event", "errors")
      K2CommonWebhook.components(the_body, @amount, @currency, @reference, @origination_time, resource_status)
      K2BuyGoods.components(the_body, @msisdn, @till_number, @system, @first_name, @middle_name, @last_name)
    end

  end

  class K2ProcessPay < K2Payment
    attr_accessor :destination,
                  :value

    def components(the_body)
      @status = the_body.dig("status")
      @reference = the_body.dig("reference")
      @origination_time = the_body.dig("origination_time")
      @destination = the_body.dig("destination")
      @amount = the_body.dig("amount")
      @currency = the_body.dig("amount", "currency")
      @value = the_body.dig("amount", "value")
    end

  end

end