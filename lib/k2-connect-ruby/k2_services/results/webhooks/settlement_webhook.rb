class SettlementWebhook < K2CommonEvents
  attr_reader :resource_transfer_time,
              :resource_transfer_type,
              :resource_destination,
              :resource_destination_type,
              :resource_destination_msisdn,
              :resource_destination_mm_system

  def initialize(payload)
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