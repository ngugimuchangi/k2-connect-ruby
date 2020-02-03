class K2Transaction
  attr_reader :data,
  :id,
  :type,
  :attributes,
  :metadata,
  :links,
  :links_self,
  :callback_url

  def components(payload)
    @data = payload.dig('data')
    @id = payload.dig('data', 'id')
    @type = payload.dig('data', 'type')
    @attributes = payload.dig('data', 'attributes')
    @metadata = payload.dig('data', 'attributes', 'meta_data')
    @links = payload.dig('data', 'attributes', '_links')
    @links_self = payload.dig('data', 'attributes', '_links', 'self')
    @callback_url = payload.dig('data', 'attributes', '_links', 'callback_url')
  end
end

class CommonPayments < K2Transaction
  attr_reader :status,
  :initiation_time

  def components(payload)
    super
    @status = payload.dig('data', 'attributes', 'status')
    @initiation_time = payload.dig('data', 'attributes', 'initiation_time')
  end

end

class IncomingPayments < CommonPayments
  attr_reader :event,
  :event_type,
  :event_resource,
  :transaction_reference,
  :origination_time,
  :sender_msisdn,
  :amount,
  :currency,
  :till_identifier,
  :system,
  :resource_status,
  :sender_first_name,
  :sender_last_name,
  :errors

  def components(payload)
    super
    @event = payload.dig('data', 'attributes', 'event')
    @event_type = payload.dig('data', 'attributes', 'event', 'type')
    @event_resource = payload.dig('data', 'attributes', 'event', 'resource')
    @transaction_reference = payload.dig('data', 'attributes', 'event', 'resource', 'transaction_reference')
    @origination_time = payload.dig('data', 'attributes', 'event', 'resource', 'origination_time')
    @sender_msisdn = payload.dig('data', 'attributes', 'event', 'resource', 'sender_msisdn')
    @amount = payload.dig('data', 'attributes', 'event', 'resource', 'amount')
    @currency = payload.dig('data', 'attributes', 'event', 'resource', 'currency')
    @till_identifier = payload.dig('data', 'attributes', 'event', 'resource', 'till_identifier')
    @system = payload.dig('data', 'attributes', 'event', 'resource', 'system')
    @resource_status = payload.dig('data', 'attributes', 'event', 'resource', 'status')
    @sender_first_name = payload.dig('data', 'attributes', 'event', 'resource', 'sender_first_name')
    @sender_last_name = payload.dig('data', 'attributes', 'event', 'resource', 'sender_last_name')
    @errors = payload.dig('data', 'attributes', 'event', 'errors')
  end

end

class OutgoingPayments < CommonPayments
  attr_reader :transaction_reference,
  :destination,
  :amount,
  :currency,
  :value,
  :origination_time

  def components(payload)
    super
    @transaction_reference = payload.dig('data', 'attributes', 'transaction_reference')
    @destination = payload.dig('data', 'attributes', 'destination')
    @amount = payload.dig('data', 'attributes', 'amount')
    @currency = payload.dig('data', 'attributes', 'amount', 'currency')
    @value = payload.dig('data', 'attributes', 'amount', 'value')
    @origination_time = payload.dig('data', 'attributes', 'origination_time')
  end

end