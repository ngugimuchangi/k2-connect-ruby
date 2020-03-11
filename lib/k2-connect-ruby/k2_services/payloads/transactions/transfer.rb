class Transfer < OutgoingTransaction
  attr_reader :destination_reference,
              :destination_type

  def initialize(payload)
    super
    @destination_reference = payload.dig('data', 'attributes', 'destination_reference')
    @destination_type = payload.dig('data', 'attributes', 'destination_type')
  end
end