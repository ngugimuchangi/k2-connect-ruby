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
    # Metadata
    @metadata = the_body.dig('metadata')
    @notes = @metadata.dig('notes')
    @customer_id = @metadata.dig('customer_id')
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
    # Links
    @link_resource = @links.dig('resource')
    @payment_request = @links.dig('payment_request')
    # Event
    @errors = the_body.dig('event','errors')
    # Metadata
    @metadata = the_body.dig('metadata')
    @notes = @metadata.dig('notes')
    @customer_id = @metadata.dig('customer_id')
    @metadata_reference = @metadata.dig('reference')
  end
end

class K2FailedStk < BuyGoods
  attr_reader :notes,
              :errors,
              :error_code,
              :error_description,
              :metadata,
              :customer_id,
              :payment_request,
              :metadata_reference

  def components(the_body)
    super
    @status = the_body.dig('status')
    # Links
    @payment_request = the_body.dig('_links','payment_request')
    # Metadata
    @metadata = the_body.dig('metadata')
    @notes = @metadata.dig('notes')
    @customer_id = @metadata.dig('customer_id')
    @metadata_reference = @metadata.dig('reference')
    # Errors
    @errors = the_body.dig('event','errors')
    @error_code = @errors.dig(0, 'code')
    @error_description = @errors.dig(0, 'description')
  end
end

class K2ProcessPay < K2Payment
  attr_reader :value,
              :destination

  def components(the_body)
    super
    @reference = the_body.dig('reference')
    @destination = the_body.dig('destination')
    @origination_time = the_body.dig('origination_time')
    # Amount
    @amount = the_body.dig('amount')
    @value = @amount.dig('value')
    @currency = @amount.dig('currency')
  end
end
