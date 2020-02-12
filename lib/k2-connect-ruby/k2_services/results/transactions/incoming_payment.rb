class IncomingPayments < CommonPayment
  attr_reader :event_type,
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

  def self.new(payload)
    super
    @event_type = payload.dig('data', 'attributes', 'event', 'type')
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