class OutgoingPayment < OutgoingTransaction
  attr_reader :transaction_reference,
              :destination

  def initialize(payload)
    super
  end

  private

  def valid_payment_type
    raise ArgumentError, "Wrong Payment Type" unless @type.eql?("payment")
  end

end