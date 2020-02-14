class OutgoingPayment < CommonPayment
  attr_reader :transaction_reference,
              :destination,
              :amount,
              :currency,
              :value,
              :origination_time

  def initialize(payload)
    super
    @transaction_reference = payload.dig('data', 'attributes', 'transaction_reference')
    @destination = payload.dig('data', 'attributes', 'destination')
    @amount = payload.dig('data', 'attributes', 'amount')
    @currency = payload.dig('data', 'attributes', 'amount', 'currency')
    @value = payload.dig('data', 'attributes', 'amount', 'value')
    @origination_time = payload.dig('data', 'attributes', 'origination_time')
  end

end