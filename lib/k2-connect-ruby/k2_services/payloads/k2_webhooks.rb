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
  attr_reader :reference,
  :origination_time,
  :amount,
  :currency,
  :status

  def initialize(payload)
    super
    @reference = payload.dig('event', 'resource', 'reference')
    @origination_time = payload.dig('event', 'resource', 'origination_time')
    @amount = payload.dig('event', 'resource', 'amount')
    @currency = payload.dig('event', 'resource', 'currency')
    @status = payload.dig('event', 'resource', 'status')
  end

end

class Buygoods < K2CommonEvents
  attr_reader :system,
              :till_number,
              :sender_phone_number,
              :sender_first_name,
              :sender_last_name

  def initialize(payload)
    super
    @system = payload.dig('event', 'resource', 'system')
    @till_number = payload.dig('event', 'resource', 'till_number')
    @sender_phone_number = payload.dig('event', 'resource', 'sender_phone_number')
    @sender_first_name = payload.dig('event', 'resource', 'sender_first_name')
    @sender_last_name = payload.dig('event', 'resource', 'sender_last_name')
  end
end