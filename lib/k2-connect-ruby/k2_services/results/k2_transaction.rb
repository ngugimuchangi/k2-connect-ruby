class K2Transaction
  attr_reader :data,
  :id,
  :type,
  :metadata,
  :links_self,
  :callback_url

  def self.new(payload)
    @id = payload.dig('data', 'id')
    @type = payload.dig('data', 'type')
    @links_self = payload.dig('data', 'attributes', '_links', 'self')
    @callback_url = payload.dig('data', 'attributes', '_links', 'callback_url')
  end
end

class CommonPayment < K2Transaction
  attr_reader :status,
  :initiation_time

  def self.new(payload)
    super
    @status = payload.dig('data', 'attributes', 'status')
    @initiation_time = payload.dig('data', 'attributes', 'initiation_time')
  end
end