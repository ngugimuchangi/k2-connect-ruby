class K2Payment < K2Result
  attr_reader :metadata,
              :customer_id,
              :notes,
              :status,
              :reference,
              :origination_time

  def components(the_body)
    @metadata = the_body.dig("metadata")
    @customer_id = the_body.dig("metadata", "customer_id")
    @notes = the_body.dig("metadata", "notes")
    @status = the_body.dig("status")
  end
end

class K2ProcessStk < BuyGoods
  attr_reader :payment_request,
              :metadata_reference,
              :link_resource,
              :metadata,
              :customer_id,
              :notes,
              :errors

  def components(the_body)
    super
    @status = the_body.dig("status")
    @payment_request = the_body.dig("_links", "payment_request")
    @metadata_reference = the_body.dig("metadata", "reference")
    @link_resource = the_body.dig("_links", "resource")
    @errors = the_body.dig("event", "errors")
    @metadata = the_body.dig("metadata")
    @customer_id = the_body.dig("metadata", "customer_id")
    @notes = the_body.dig("metadata", "notes")
  end
end

class K2ProcessPay < K2Payment
  attr_reader :destination,
              :value

  def components(the_body)
    super
    @reference = the_body.dig("reference")
    @origination_time = the_body.dig("origination_time")
    @destination = the_body.dig("destination")
    @amount = the_body.dig("amount")
    @currency = the_body.dig("amount", "currency")
    @value = the_body.dig("amount", "value")
  end
end
