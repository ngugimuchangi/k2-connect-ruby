class IncomingPayments < CommonPayment
  attr_reader :event,
              :event_type,
              :transaction_reference,
              :origination_time,
              :sender_phone_number,
              :amount,
              :currency,
              :till_number,
              :system,
              :resource_id,
              :resource_status,
              :sender_first_name,
              :sender_middle_name,
              :sender_last_name,
              :errors

  def initialize(payload)
    super
    # Event details
    @event = payload.dig('data', 'attributes', 'event')
    @event_type = payload.dig('data', 'attributes', 'event', 'type')
    # Resource details
    @resource_id = payload.dig('data', 'attributes', 'event', 'resource', 'id')
    @transaction_reference = payload.dig('data', 'attributes', 'event', 'resource', 'reference')
    @origination_time = payload.dig('data', 'attributes', 'event', 'resource', 'origination_time')
    @sender_phone_number = payload.dig('data', 'attributes', 'event', 'resource', 'sender_phone_number')
    @amount = payload.dig('data', 'attributes', 'event', 'resource', 'amount')
    @currency = payload.dig('data', 'attributes', 'event', 'resource', 'currency')
    @till_number = payload.dig('data', 'attributes', 'event', 'resource', 'till_number')
    @system = payload.dig('data', 'attributes', 'event', 'resource', 'system')
    @resource_status = payload.dig('data', 'attributes', 'event', 'resource', 'status')
    @sender_first_name = payload.dig('data', 'attributes', 'event', 'resource', 'sender_first_name')
    @sender_middle_name = payload.dig('data', 'attributes', 'event', 'resource', 'sender_middle_name')
    @sender_last_name = payload.dig('data', 'attributes', 'event', 'resource', 'sender_last_name')
    # Errors
    @errors = payload.dig('data', 'attributes', 'event', 'errors')
  end

end