class K2Query < K2Result
  attr_reader :value,
              :status,
              :amount,
              :currency

  def components(the_body)
    super
    @status = the_body.dig('status')
    # Amount
    @amount = the_body.dig('amount')
    @value = @amount.dig('value')
    @currency = @amount.dig('currency')
  end
end

class QueryStk < K2Query
  def components(the_body)
    super
    @currency = the_body.dig('currency')
  end
end

class QueryPay < K2Query
  attr_reader :notes,
              :metadata,
              :reference,
              :destination,
              :customer_id,
              :origination_time

  def components(the_body)
    super
    @reference = the_body.dig('reference')
    @destination = the_body.dig('destination')
    @origination_time = the_body.dig('origination_time')
    # Metadata
    @metadata = the_body.dig('metadata')
    @notes = @metadata.dig('notes')
    @customer_id = @metadata.dig('customerId')
  end
end

class QueryTransfer < K2Query
  attr_reader :initiated_at,
              :completed_at

  def components(the_body)
    super
    @initiated_at = the_body.dig('initiated_at')
    @completed_at = the_body.dig('completed_at')
  end
end
