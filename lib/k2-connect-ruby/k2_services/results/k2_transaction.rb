class K2Payment < K2Result
  attr_reader :notes,
              :status,
              :metadata,
              :reference,
              :customer_id,
              :origination_time

  def components(the_body)
    super
    @status = the_body.dig('status')
    @metadata = the_body.dig('metadata')
    @notes = the_body.dig('metadata', 'notes')
    @customer_id = the_body.dig('metadata', 'customer_id')
  end
end

class K2ProcessStk < BuyGoods
  attr_reader :notes,
              :errors,
              :metadata,
              :customer_id,
              :link_resource,
              :payment_request,
              :metadata_reference

  def components(the_body)
    super
    @status = the_body.dig('status')
    @metadata = the_body.dig('metadata')
    @errors = the_body.dig("event", "errors")
    @notes = the_body.dig("metadata", "notes")
    @link_resource = the_body.dig("_links", "resource")
    @customer_id = the_body.dig("metadata", "customer_id")
    @metadata_reference = the_body.dig("metadata", "reference")
    @payment_request = the_body.dig("_links", "payment_request")
  end
end

class K2ProcessPay < K2Payment
  attr_reader :value,
              :destination

  def components(the_body)
    super
    @amount = the_body.dig("amount")
    @reference = the_body.dig("reference")
    @value = the_body.dig("amount", "value")
    @destination = the_body.dig("destination")
    @currency = the_body.dig("amount", "currency")
    @origination_time = the_body.dig("origination_time")
  end
end
