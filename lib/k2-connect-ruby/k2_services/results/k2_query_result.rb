class K2Query < K2Result
  attr_reader :value,
              :status,
              :amount,
              :currency

  def components(the_body)
    super
    @amount = the_body.dig('amount')
    @status = the_body.dig('status')
    @value = the_body.dig('amount', 'value')
    @currency = the_body.dig('amount', 'currency')
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
    @metadata = the_body.dig('metadata')
    @reference = the_body.dig('reference')
    @notes = the_body.dig('metadata', 'notes')
    @destination = the_body.dig('destination')
    @origination_time = the_body.dig('origination_time')
    @customer_id = the_body.dig('metadata', 'customerId')
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
