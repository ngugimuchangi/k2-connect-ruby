class K2Transaction
  attr_reader :id,
              :type,
              :metadata,
              :links_self,
              :callback_url

  def initialize(payload)
    @id = payload.dig('data', 'id')
    @type = payload.dig('data', 'type')
    @metadata = payload.dig('data', 'attributes', 'metadata')
    @links_self = payload.dig('data', 'attributes', '_links', 'self')
    @callback_url = payload.dig('data', 'attributes', '_links', 'callback_url')
  end
end

class CommonPayment < K2Transaction
  attr_reader :status,
              :initiation_time

  validate :valid_payment_type

  def initialize(payload)
    super
    @status = payload.dig('data', 'attributes', 'status')
    @initiation_time = payload.dig('data', 'attributes', 'initiation_time') if @type.eql?('incoming_payment')
  end

  private

  def valid_payment_type; end
end

class OutgoingTransaction < CommonPayment
  attr_reader :created_at,
              :transfer_batches,
              :total_value

  def initialize(payload)
    super
    @created_at = payload.dig('data', 'attributes', 'created_at')
    @currency = payload.dig('data', 'attributes', 'amount', 'currency')
    @total_value = payload.dig('data', 'attributes', 'amount', 'value')
    @transfer_batches = payload.dig('data', 'attributes', 'transfer_batches')
  end
end