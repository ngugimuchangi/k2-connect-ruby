class OutgoingPayment < OutgoingTransaction
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
  end

end