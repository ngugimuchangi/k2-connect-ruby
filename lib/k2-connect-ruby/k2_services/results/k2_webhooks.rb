class Webhook
  attr_reader :id,
              :links,
              :event,
              :topic,
              :created_at,
              :links_self,
              :event_type,
              :links_resource,
              :event_resource,
              :resource_id

  def components(payload)
    @id = payload.dig('id')
    @topic = payload.dig('topic')
    @created_at = payload.dig('created_at')
    # Event
    # @event = payload.dig('event')
    @event_type = payload.dig('event', 'type')
    @event_resource = payload.dig('event', 'resource')
    @resource_id = payload.dig('event', 'resource', 'id')
    # Links
    # @links = payload.dig('_links')
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

  def components(payload)
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

  def components(payload)
    super
    @resource_system = payload.dig('event', 'resource', 'system')
    @resource_till_number = payload.dig('event', 'resource', 'till_number')
    @resource_sender_msisdn = payload.dig('event', 'resource', 'sender_msisdn')
    @resource_sender_first_name = payload.dig('event', 'resource', 'sender_first_name')
    @resource_sender_last_name = payload.dig('event', 'resource', 'sender_last_name')
  end
end

class BuygoodsTransactionReceived < Buygoods
  def components(payload)
    super
  end
end

class BuygoodsTransactionReversed < Buygoods
  attr_reader :resource_reversal_time

  def components(payload)
    super
    @resource_reversal_time = payload.dig('event', 'resource', 'reversal_time')
  end
end

class B2b < K2CommonEvents
  attr_reader :resource_sending_till

  def components(payload)
    super
    @resource_sending_till = payload.dig('event', 'resource', 'sending_till')
  end
end

class MerchantToMerchant < K2CommonEvents
  attr_reader :resource_sending_merchant

  def components(payload)
    super
    @resource_sending_merchant = payload.dig('event', 'resource', 'sending_merchant')
  end
end

class Settlements < K2CommonEvents
  attr_reader :resource_transfer_time,
  :resource_transfer_type,
  :resource_destination,
  :resource_destination_type,
  :resource_destination_msisdn,
  :resource_destination_mm_system

  def components(payload)
    super
    @resource_transfer_time = payload.dig('event', 'resource', 'transfer_time')
    @resource_transfer_type = payload.dig('event', 'resource', 'transfer_type')
    # Destination
    @resource_destination = payload.dig('event', 'resource', 'destination')
    @resource_destination_type = payload.dig('event', 'resource', 'destination', 'type')
    @resource_destination_msisdn = payload.dig('event', 'resource', 'destination', 'msisdn')
    @resource_destination_mm_system = payload.dig('event', 'resource', 'destination', 'mm_system')
  end
end

class CustomerCreated < Webhook
  attr_reader :resource_first_name,
              :resource_middle_name,
              :resource_last_name,
              :resource_msisdn

  def components(payload)
    super
    @resource_first_name = payload.dig('resource', 'first_name')
    @resource_middle_name = payload.dig('resource', 'middle_name')
    @resource_last_name = payload.dig('resource', 'last_name')
    @resource_msisdn = payload.dig('resource', 'msisdn')
  end
end