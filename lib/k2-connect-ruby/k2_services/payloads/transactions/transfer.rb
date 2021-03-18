class Transfer < OutgoingTransaction

  def initialize(payload)
    super
    @transfer_batches = payload.dig('data', 'attributes', 'transfer_batches')
  end
end