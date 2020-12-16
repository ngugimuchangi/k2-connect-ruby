class K2Transaction
  attr_reader :data,
  :id,
  :type,
  :metadata,
  :links_self,
  :callback_url

  def initialize(payload)
    @id = payload.dig('data', 'id')
    @type = payload.dig('data', 'type')
    @metadata = payload.dig('data', 'attributes', 'meta_data')
    @links_self = payload.dig('data', 'attributes', '_links', 'self')
    @callback_url = payload.dig('data', 'attributes', '_links', 'callback_url')
  end
end

class CommonPayment < K2Transaction
  attr_reader :status,
  :initiation_time

  def initialize(payload)
    super
    @status = payload.dig('data', 'attributes', 'status')
    @initiation_time = payload.dig('data', 'attributes', 'initiation_time')
  end
end

class OutgoingTransaction < CommonPayment
  attr_reader :value,
              :currency,
              :origination_time

  def initialize(payload)
    super
    @currency = payload.dig('data', 'attributes', 'amount', 'currency')
    @value = payload.dig('data', 'attributes', 'amount', 'value')
    @origination_time = payload.dig('data', 'attributes', 'origination_time')
  end
end