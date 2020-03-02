class Webhook
  attr_reader :id,
              :topic,
              :created_at,
              :links_self,
              :event_type,
              :links_resource,
              :event_resource,
              :resource_id

  def initialize(payload)
    @id = payload.dig('id')
    @topic = payload.dig('topic')
    @created_at = payload.dig('created_at')
    # Event
    @event_type = payload.dig('event', 'type')
    @resource_id = payload.dig('event', 'resource', 'id')
    # Links
    @links_self = payload.dig('_links', 'self')
    @links_resource = payload.dig('_links', 'resource')
  end
end

class K2CommonEvents < Webhook
  attr_reader :resource_reference,
  :resource_origination_time,
  :resource_amount,
  :resource_currency,
  :resource_status

  def initialize(payload)
    super
    @resource_reference = payload.dig('event', 'resource', 'reference')
    @resource_origination_time = payload.dig('event', 'resource', 'origination_time')
    @resource_amount = payload.dig('event', 'resource', 'amount')
    @resource_currency = payload.dig('event', 'resource', 'currency')
    @resource_status = payload.dig('event', 'resource', 'status')
  end

end

class Buygoods < K2CommonEvents
  attr_reader :resource_system,
              :resource_till_number,
              :resource_sender_msisdn,
              :resource_sender_first_name,
              :resource_sender_last_name

  def initialize(payload)
    super
    @resource_system = payload.dig('event', 'resource', 'system')
    @resource_till_number = payload.dig('event', 'resource', 'till_number')
    @resource_sender_msisdn = payload.dig('event', 'resource', 'sender_msisdn')
    @resource_sender_first_name = payload.dig('event', 'resource', 'sender_first_name')
    @resource_sender_last_name = payload.dig('event', 'resource', 'sender_last_name')
  end
end